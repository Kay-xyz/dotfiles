-- lualine：状态栏
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})
-- 显示当前 buffer 激活的 LSP 客户端名称
local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if vim.tbl_isempty(clients) then
		return ""
	end
	local names = {}
	for _, client in ipairs(clients) do
		local name = client.name
		if not vim.tbl_contains(names, name) then
			table.insert(names, name)
		end
	end
	return vim.fn.join(names, ", ")
end

require("lualine").setup({
	options = {
		-- 去掉 section 之间的三角分隔符，组件之间用竖线分割
		section_separators = "",
		component_separators = { left = "|", right = "|" },
		-- 文件树窗口不显示状态栏
		disabled_filetypes = {
			statusline = { "NvimTree", "neo-tree" },
		},
		ignore_focus = { "NvimTree", "neo-tree" },
	},
	sections = {
		lualine_x = { { lsp_status } },
		lualine_y = {},
	},
})
