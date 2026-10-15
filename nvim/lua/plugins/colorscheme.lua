vim.pack.add({
	"https://github.com/oneslash/helix-nvim",
})
vim.cmd.colorscheme("helix")

--修复()显示bug
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#6c6999" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#281733" })

--bufferline颜色自定义
vim.api.nvim_set_hl(0, "BufferLineBufferSelected", {
	fg = "#A4A0E8",
	bg = "#3B224C",
	-- bold = true,
})

vim.api.nvim_set_hl(0, "BufferLineFill", {
	bg = "#2C1939",
})

-- vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "#2C1939" })
-- vim.api.nvim_set_hl(0, "lualine_x_normal", { bg = "#2C1939" })

--错误提示改为红色：主题的 Error 是 apricot #f47868（偏橙），调色板里没有红色
--DiagnosticSignError / DiagnosticVirtualLinesError / DiagnosticVirtualTextError
-- / DiagnosticFloatingError 都链接到 DiagnosticError，改这一处会全部跟着变
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff5555" })
