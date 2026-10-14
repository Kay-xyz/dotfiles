vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Rust：root_dir 取最外层的 Cargo.toml，避免 cargo workspace 中每个 crate 各起一个 server
vim.lsp.config['rust_analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root, dir = nil, vim.fs.dirname(fname)
        while dir and dir ~= '' do
            if vim.uv.fs_stat(vim.fs.joinpath(dir, 'Cargo.toml')) then
                root = dir
            end
            local parent = vim.fs.dirname(dir)
            if parent == dir then
                break
            end
            dir = parent
        end
        on_dir(root or vim.fs.root(fname, 'rust-project.json') or vim.fs.root(fname, '.git'))
    end,
}

-- Go：优先 go.work（多模块工作区），其次 go.mod
vim.lsp.config['gopls'] = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git'))
    end,
}

-- Zig：需要 zls 在 PATH 中（当前系统只装了 zig 编译器，zls 需另行安装）
vim.lsp.config['zls'] = {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    root_markers = { 'build.zig', 'build.zig.zon', 'zls.json', '.git' },
    workspace_required = false,
}

-- blink.cmp 不会自动注入补全能力，这里统一交给所有 LSP 客户端（0.11+ 官方做法）
vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'gopls', 'zls' })

-- 诊断显示：符号列用 lualine 状态栏同一套 Nerd Font 图标，两处保持一致
--   错误 󰅚(圆里带叉) #ff5555 红 / 警告 󰀪 #ffcd1c 黄 / 信息 󰋽 #6f44f0 紫 / 提示 󰌶 #cccccc 灰
--   码位依次是 U+F015A / U+F002A / U+F02FD / U+F0336，与 lualine 默认 icons 完全相同。
-- 想四个级别都用同一个字符，把上面四个值改成同一个即可（例如都填 '󰅚' 或 '●'）。
-- 虚拟行：只展开光标所在行的诊断消息，不会把整个文件撑开。
--   想让整篇文件都展开：去掉 current_line，并加 severity = { vim.diagnostic.severity.ERROR } 只留错误。
-- severity_sort = true：让符号列按严重程度决定优先级（错误 13 > 警告 12 > 信息 11 > 提示 10）。
--   不开这个时所有诊断符号优先级都等于 10，同一行有多个诊断时显示哪个只取决于先后顺序，
--   于是会出现「警告的图标盖住错误的图标」。注意它不影响虚拟行的顺序 —— 虚拟行是按
--   lnum → col → end_lnum → end_col → 插入顺序排的，severity 不在排序键里。
vim.diagnostic.config({
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌶',
        },
    },
    virtual_lines = {
        current_line = true,
    },
})

-- 保存时格式化：只在当前缓冲区确实有支持格式化的 LSP 客户端时才调用，
-- 否则 vim.lsp.buf.format 会在没有 formatter 的文件上保存时报错。
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        local clients = vim.lsp.get_clients({
            bufnr = args.buf,
            method = 'textDocument/formatting',
        })
        if #clients > 0 then
            vim.lsp.buf.format({ bufnr = args.buf, async = false })
        end
    end,
})
