-- LSP 配置（通过 mason 管理语言服务器，使用 0.11+ 内置的 vim.lsp 配置）
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
})

require("mason").setup()

-- 诊断显示：在行末以 virtual text 内联显示错误信息
vim.diagnostic.config({
	virtual_text = {
		prefix = "•",
		source = false,
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "●",
			[vim.diagnostic.severity.INFO] = "●",
			[vim.diagnostic.severity.HINT] = "●",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

require("mason-lspconfig").setup({
	-- 首次打开时自动安装的语言服务器
	ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "zls" },
	automatic_installation = true,
})

-- mason 将二进制安装到 ~/.local/share/nvim/mason/bin，加入 PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- 使用 Neovim 0.11+ 内置的 LSP 配置（替代已弃用的 lspconfig 框架）
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		".git",
	},
})

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.mod", "go.work" },
})

vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "build.zig", "build.zig.zon", ".git" },
})

-- 为每个通过 mason 安装的 LSP 自动启用
for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
	if vim.lsp.config[server_name] then
		vim.lsp.enable(server_name)
	end
end

-- 统一的 LSP 导航键位（gd 等），在 LSP attach 时绑定到当前 buffer
vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			foldProvider = true,
		},
	},
	on_attach = function(client, bufnr)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
		map("n", "gr", vim.lsp.buf.references, "跳转到引用")
		map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
		map("n", "gI", vim.lsp.buf.implementation, "跳转到实现")
		map("n", "<space>k", vim.lsp.buf.hover, "悬停文档")
		map("n", "<leader>rn", vim.lsp.buf.rename, "重命名")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")
	end,
})
