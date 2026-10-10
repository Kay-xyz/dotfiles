-- toggleterm.nvim：终端切换
vim.pack.add({
	"https://github.com/akinsho/toggleterm.nvim",
})

require("toggleterm").setup({
	size = function(term)
		if term.direction == "float" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = [[<C-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
	lazygit:toggle()
end

local node = Terminal:new({ cmd = "node", hidden = true, direction = "float" })

function _node_toggle()
	node:toggle()
end

-- 关键词优先级：float、horizontal、vertical
vim.keymap.set("n", "<Space>tf", "<Cmd>ToggleTerm direction=float<CR>", { desc = "浮动终端" })
vim.keymap.set("n", "<Space>th", "<Cmd>ToggleTerm direction=horizontal size=15<CR>", { desc = "横向终端" })
vim.keymap.set("n", "<Space>tv", "<Cmd>ToggleTerm direction=vertical size=80<CR>", { desc = "纵向终端" })
vim.keymap.set("n", "<Space>tg", "<Cmd>lua _lazygit_toggle()<CR>", { desc = "切换 lazygit" })
