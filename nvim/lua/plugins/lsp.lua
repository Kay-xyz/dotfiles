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

-- Zig：zls 已通过 mason 安装，PATH 在 options.lua 里已统一补上
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

-- 保存时格式化已交给 conform.nvim（plugins/conform.lua）统一管理，
-- 这里不再单独注册 BufWritePre，避免双重格式化。

-- 复制代码错误/警告提示到系统剪贴板
-- 格式：文件:行:列: 级别: 消息 [来源] (错误码)
-- <leader>cd 复制光标所在行的诊断，<leader>cD 复制整个文件的诊断
local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'Error',
    [vim.diagnostic.severity.WARN] = 'Warning',
    [vim.diagnostic.severity.INFO] = 'Info',
    [vim.diagnostic.severity.HINT] = 'Hint',
}

local function format_diagnostic(d)
    local file = vim.api.nvim_buf_get_name(d.bufnr)
    local severity = severity_names[d.severity] or 'Unknown'
    local source = d.source and (' [' .. d.source .. ']') or ''
    local code = d.code and (' (' .. tostring(d.code) .. ')') or ''
    return string.format('%s:%d:%d: %s: %s%s%s', file, d.lnum + 1, d.col + 1, severity, d.message, source, code)
end

local function copy_diagnostics(scope)
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = {}
    if scope == 'line' then
        opts.lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    end

    local diags = vim.diagnostic.get(bufnr, opts)
    if #diags == 0 then
        vim.notify(scope == 'line' and '当前行没有诊断信息' or '当前文件没有诊断信息', vim.log.levels.INFO)
        return
    end

    table.sort(diags, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        return a.col < b.col
    end)

    local lines = {}
    for _, d in ipairs(diags) do
        table.insert(lines, format_diagnostic(d))
    end
    local text = table.concat(lines, '\n')

    vim.fn.setreg('+', text)
    vim.fn.setreg('"', text)
    vim.notify('已复制 ' .. #diags .. ' 条诊断信息', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('CopyLineDiagnostics', function()
    copy_diagnostics('line')
end, { desc = '复制当前行的诊断信息' })

vim.api.nvim_create_user_command('CopyDiagnostics', function()
    copy_diagnostics('buffer')
end, { desc = '复制当前文件的诊断信息' })

vim.keymap.set('n', '<leader>cd', function()
    copy_diagnostics('line')
end, { desc = '复制本行错误提示' })

vim.keymap.set('n', '<leader>cD', function()
    copy_diagnostics('buffer')
end, { desc = '复制整个文件的错误提示' })
