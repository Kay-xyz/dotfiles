local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.fillchars = { eob = " " }
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.expandtab = true    -- 关键：将 Tab 键输入转换为空格
opt.tabstop = 4         -- 一个 Tab 字符显示为 4 个空格宽度
opt.softtabstop = 4     -- 编辑时按 Tab 键，插入 4 个空格
opt.shiftwidth = 4      -- 自动缩进（>> 或 <<）时移动 4 个空格
opt.confirm = true
