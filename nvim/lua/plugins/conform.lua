-- conform.nvim：格式化（保存时自动格式化）
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

-- 确保 stylua 已通过 mason 安装（用于 Lua 格式化）
local mason_registry = require("mason-registry")
if not mason_registry.is_installed("stylua") then
	mason_registry.get_package("stylua"):install()
end

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		zig = { "zigfmt" },
	},
	-- 保存时自动格式化
	format_on_save = {
		timeout_ms = 5000,
		lsp_format = "fallback",
	},
	-- 格式化器命令补全：stylua 用 mason 目录，其余走系统 PATH
	formatters = {
		stylua = {
			command = mason_bin .. "/stylua",
		},
	},
})
