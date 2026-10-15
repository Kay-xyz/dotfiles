-- conform.nvim：代码格式化（format-on-save，统一管理）
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		go = { "gofmt" },
		zig = { "zigfmt" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		-- 需要时再补：
		-- python = { "ruff_format" },
		-- javascript = { "prettierd" },
		-- typescript = { "prettierd" },
	},
	format_on_save = {
		timeout_ms = 500,
		-- 没在上面配置 formatter 的文件类型，回退到 LSP 格式化
		lsp_format = "fallback",
	},
})
