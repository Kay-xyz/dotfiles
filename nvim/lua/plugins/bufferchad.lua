vim.pack.add({
	"https://github.com/mrquantumcodes/bufferchad.nvim",
})

require("bufferchad").setup({
	mapping = "<tab>",
	style = "telescope",
})
