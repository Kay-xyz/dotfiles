-- toggleterm.nvim：终端切换（只使用浮动模式）
vim.pack.add({
	"https://github.com/akinsho/toggleterm.nvim",
})

require("toggleterm").setup({
	-- 全局快捷键：<C-\>，普通 / 插入 / 终端三种模式都能切换
	-- （insert_mappings 让它进插入模式，terminal_mappings 默认开启让它进终端模式）
	open_mapping = [[<C-\>]],
	direction = "float",
	hide_numbers = true,
	-- 终端背景不遮暗，和编辑器同色；想区分开就改成 shade_terminals = true（默认 shading_factor = -30）
	shade_terminals = false,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		width = function()
			return math.ceil(vim.o.columns * 0.85)
		end,
		height = function()
			return math.ceil(vim.o.lines * 0.8)
		end,
	},
})

-- normal 模式下的顺手键：单键 <Space>t，比 <Space>tt 更好按
vim.keymap.set("n", "<Space>t", "<Cmd>ToggleTerm<CR>", { desc = "浮动终端" })
