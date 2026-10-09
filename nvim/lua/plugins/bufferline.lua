-- bufferline：缓冲区标签栏
vim.pack.add({
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("bufferline").setup({
  options = {
    mode = "buffers",          -- 默认即是 buffers 模式，显示所有打开的缓冲区
    indicator = {
      style = "icon",  -- 可选值还有 "icon"（默认）、"none"
    },
    separator_style = "thin",  -- 分隔符样式，可选 "thin", "thick", "slant"
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    diagnostics = "nvim_lsp",  -- 显示 LSP 诊断信息（错误/警告数量）
    offsets = {                -- 与 nvim-tree 的集成，避免顶栏被文件树遮挡
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})
