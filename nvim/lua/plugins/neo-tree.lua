-- neo-tree：文件树
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/MunifTanjim/nui.nvim",
})

require("neo-tree").setup({
	window = {
		width = 25,
		mappings = {
			["l"] = "open", -- 打开文件或展开目录
			["h"] = "close_node", -- 折叠目录
		},
	},
})

vim.keymap.set("n", "<Space>e", "<Cmd>Neotree toggle<CR>", { desc = "开关文件树" })
