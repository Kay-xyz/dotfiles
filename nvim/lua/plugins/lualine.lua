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
		globalstatus = true,
		-- 去掉 section 之间的三角分隔符，组件之间用竖线分割
		section_separators = "",
		component_separators = { left = "|", right = "|" },
		-- 文件树窗口不显示状态栏
	},
	sections = {
		lualine_a = { "branch" },
		lualine_b = {},
		lualine_c = {
			{ "filename", path = 4 }, -- 显示为「上级文件夹/文件名」
			"diff",
			-- 错误图标颜色在这里单独指定：lualine 在 setup 时就把颜色固化了，
			-- 不会跟着 colorscheme.lua 里的 DiagnosticError 走
			{ "diagnostics", diagnostics_color = { error = { fg = "#ff5555" } } },
		},
		lualine_x = { lsp_status },
		lualine_y = {},
		lualine_z = {},
	},
})
