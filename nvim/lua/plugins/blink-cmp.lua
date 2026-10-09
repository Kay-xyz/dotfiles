-- blink.cmp：代码补全
vim.pack.add({
  "https://github.com/saghen/blink.cmp",
  "https://github.com/saghen/blink.lib",
})

require("blink.cmp").setup({
  -- LSP 补全能力默认自动启用，无需手动配置 sources
  keymap = {
    preset = "default",
    ["<C-y>"] = { "select_and_accept" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },

  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },

  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },

  signature = { enabled = true },
})
