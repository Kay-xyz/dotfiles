vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/oneslash/helix-nvim",
})
vim.cmd.colorscheme("helix")
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#6c6999" })
