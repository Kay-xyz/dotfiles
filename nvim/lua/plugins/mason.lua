-- Mason：管理 LSP / DAP / linter / formatter 等工具的安装
-- 安装的语言服务器会被加入 PATH，供 vim.lsp.enable 使用
vim.pack.add({
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", -- Lua（Mason 中的包名为 lua_ls，对应 lua-language-server）
    "zls",    -- Zig
  },
})
