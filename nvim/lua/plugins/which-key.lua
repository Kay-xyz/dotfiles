-- which-key.nvim：快捷键提示面板
-- 按下 <leader> 后弹出所有以 <leader> 开头的映射及说明，不用再背快捷键
vim.pack.add({
    "https://github.com/folke/which-key.nvim",
})

require("which-key").setup({
    -- 面板出现延迟（毫秒），太快会有闪烁感，默认 200 即可
    delay = 200,
    -- 如需面板停留更久，可调大 options.lua 里的 timeoutlen（默认 1000ms）
})
