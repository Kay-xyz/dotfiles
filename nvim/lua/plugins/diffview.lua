-- diffview.nvim：图形化 git diff / 文件历史
-- 依赖 plenary.nvim（已随 telescope 安装）
vim.pack.add({
	"https://github.com/sindrets/diffview.nvim",
})

require("diffview").setup({
	-- 给 view / 文件面板 / 历史面板都加上 q 关闭（默认只有 help/option 面板有）
	keymaps = {
		view = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "关闭 diffview" } },
		},
		file_panel = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "关闭 diffview" } },
		},
		file_history_panel = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "关闭 diffview" } },
		},
	},
})

-- <leader>gd：对比工作区相对 HEAD 的全部改动
vim.keymap.set("n", "<leader>gg", "<Cmd>DiffviewOpen<CR>", { desc = "打开改动对比" })
-- <leader>gh：查看当前文件的历史提交
vim.keymap.set("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "当前文件历史" })
-- <leader>gc：关闭 diffview（焦点在任意窗口都能用）
vim.keymap.set("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "关闭 diffview" })
