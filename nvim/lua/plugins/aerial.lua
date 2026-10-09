-- aerial.nvim：代码大纲 / 符号导航
vim.pack.add({
	"https://github.com/stevearc/aerial.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("aerial").setup({
	-- 默认贴靠左侧，宽度 25%，与 neo-tree 视觉一致
	autojump = true,
	layout = {
		max_width = { 40, 0.2 },
		width = 25,
		min_width = 20,
	},
	keymaps = {
		-- 其他按键映射...
		["<Esc>"] = "actions.close",
	},
	-- 关闭时回到之前的窗口
	close_autocmds = { "BufHidden", "BufLeave" },
	-- 数据源：优先 LSP，其次 treesitter
	backends = { "lsp", "treesitter", "markdown" },
})

-- 开关大纲
vim.keymap.set("n", "<Space>a", "<Cmd>AerialToggle<CR>", { desc = "开关代码大纲" })
