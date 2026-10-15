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
	default_component_configs = {
		git_status = {
			symbols = {
				-- 只显示「是否被修改过」：modified 显示 +，其余状态一律不显示符号
				added     = "",
				deleted   = "",
				modified  = "+",
				renamed   = "",
				untracked = "",
				ignored   = "",
				unstaged  = "",
				staged    = "",
				conflict  = "",
			},
		},
	},
})

vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { desc = "开关文件树" })
