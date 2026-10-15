-- gitsigns.nvim：git 改动标记
-- 行号左侧显示 + / - / ~ 改动符号，支持 hunk 跳转、暂存、blame
vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
})

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- ]c / [c：下一个 / 上一个改动块（diff 模式下保持原生行为）
        vim.keymap.set("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "下一个改动块" })

        vim.keymap.set("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, buffer = bufnr, desc = "上一个改动块" })

        -- <leader>h 前缀的 git 操作
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "暂存改动块" })
        vim.keymap.set("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "暂存选中行" })
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "撤销改动块" })
        vim.keymap.set("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { buffer = bufnr, desc = "撤销选中行" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "预览改动块" })
        vim.keymap.set("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, { buffer = bufnr, desc = "行 blame" })
        vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "对比当前文件" })
        vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "暂存整个文件" })
    end,
})

-- 打开所有有 git 改动的文件（含已暂存 / 未暂存 / 未跟踪）
local function open_git_modified()
    local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
    if not root or root == "" then
        vim.notify("不是 git 仓库", vim.log.levels.WARN)
        return
    end

    local output = vim.fn.systemlist("git status --porcelain 2>/dev/null")
    if #output == 0 then
        vim.notify("没有 git 改动", vim.log.levels.INFO)
        return
    end

    local count = 0
    for _, line in ipairs(output) do
        local fname = line:sub(4) -- 去掉 "XY " 状态前缀
        fname = fname:match(".* -> (.*)$") or fname -- 重命名取新路径
        if fname:sub(1, 1) == '"' then
            fname = fname:sub(2, -2):gsub('\\"', '"') -- 去掉 porcelain 引号包裹
        end
        if fname ~= "" then
            vim.cmd.edit(vim.fn.fnameescape(root .. "/" .. fname))
            count = count + 1
        end
    end
    vim.notify("已打开 " .. count .. " 个修改文件", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("GitModified", open_git_modified, { desc = "打开所有 git 修改的文件" })
vim.keymap.set("n", "<leader>gm", open_git_modified, { desc = "打开所有 git 修改的文件" })
