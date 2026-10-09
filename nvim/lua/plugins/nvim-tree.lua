-- nvim-tree：文件树
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("nvim-tree").setup({
  view = {
    width = 25,          -- 侧边栏宽度
    side = "left",       -- 位置：left / right
  },
  renderer = {
    group_empty = true,  -- 折叠空目录
  },
  filters = {
    dotfiles = false,    -- 是否隐藏点文件
  },

  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- 先加载默认映射，再覆盖 h 和 l
    api.config.mappings.default_on_attach(bufnr)

    -- l 键：打开文件或展开文件夹
    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    -- h 键：关闭文件夹
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
  end,
})

vim.keymap.set("n", "<Space>e", "<Cmd>NvimTreeToggle<CR>", { desc = "开关文件树" })
