vim.opt.number =true
vim.opt.relativenumber=true
vim.opt.fillchars = { eob = " " }
vim.opt.cursorline=true
vim.opt.clipboard = "unnamedplus"

vim.keymap.set({ "n", "v" }, "H", "^", { desc = "行首" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "行尾" })
vim.keymap.set({ "n", "v" }, "J", "<C-d>", { desc = "向下翻页" })
vim.keymap.set({ "n", "v" }, "K", "<C-u>", { desc = "向上翻页" })
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "去除高亮" })
vim.keymap.set("n", "<Space>w", "<Cmd>write<CR>", { desc = "保存" })
vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { desc = "关闭当前缓冲区" })


-- 主题
-- 1. 安装（name 可省略，但建议保留以统一 require 路径）
vim.pack.add({
    "https://github.com/catppuccin/nvim",
})

-- 2. 配置（可选）
require("catppuccin").setup({
    flavour = "mocha",              -- latte / frappe / macchiato / mocha
    transparent_background = false,  -- 全局背景透明
    float = {
        transparent = true,         -- 浮动窗口透明
    },
    -- 注意：markdown、treesitter、native_lsp 等集成已默认内置，无需手动开启
})

-- 3. 加载（注意名称变化！）
vim.cmd.colorscheme("catppuccin-nvim")

-- 自动pair
vim.pack.add({ "https://github.com/nvim-mini/mini.pairs" })
require("mini.pairs").setup()


vim.pack.add({
  "https://github.com/folke/flash.nvim",
})

-- flash
local flash = require("flash")
flash.setup({
  modes = {
    char = {
      enabled = true,      -- 增强 f/t/F/T 动作
      jump_labels = true,
    },
  },
})

-- 完整按键映射（参考 flash.nvim 默认配置）
vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })



-- telescope
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim"
       and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<space><space>", builtin.find_files, { desc = "查找文件" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "全局搜索" })

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.pack.add({
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("nvim-tree").setup({
  view = {
    width = 30,          -- 侧边栏宽度
    side = "left",       -- 位置：left / right
  },
  renderer = {
    group_empty = true,  -- 折叠空目录
  },
  filters = {
    dotfiles = false,    -- 是否隐藏点文件
  },
})

vim.keymap.set("n", "<Space>e", "<Cmd>NvimTreeToggle<CR>", { desc = "开关文件树" })

vim.lsp.enable('gopls')


-- 1. 安装插件（bufferline 依赖 nvim-web-devicons 来显示图标）
vim.pack.add({
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

-- 2. 核心配置
require("bufferline").setup({
  options = {
    mode = "buffers",          -- 默认即是 buffers 模式，显示所有打开的缓冲区
    separator_style = "thin",  -- 分隔符样式，可选 "thin", "thick", "slant"
    show_buffer_close_icons = true,
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

vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "下一个缓冲区" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "上一个缓冲区" })


-- 1. 安装依赖与插件
vim.pack.add({
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",
    -- 可选：代码片段
    "https://github.com/rafamadriz/friendly-snippets",
})

-- 2. 构建模糊匹配器（必须）
require('blink.cmp').build():pwait()

-- 3. 配置
require('blink.cmp').setup({
    keymap = { preset = 'default' }, -- 或 'super-tab' 让 Tab 键接受补全
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    -- 默认使用 Rust 匹配器；若无 Rust 环境可改为 "lua"
    fuzzy = { implementation = "prefer_rust" },
})
