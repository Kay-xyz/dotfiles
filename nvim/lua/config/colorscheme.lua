vim.pack.add({
	"https://github.com/catppuccin/nvim",
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
