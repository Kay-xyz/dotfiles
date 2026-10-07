vim.opt.number =true
vim.opt.relativenumber=false
vim.opt.fillchars = { eob = " " }
vim.opt.cursorline=true
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.expandtab = true    -- 关键：将 Tab 键输入转换为空格
vim.opt.tabstop = 4         -- 一个 Tab 字符显示为 4 个空格宽度
vim.opt.softtabstop = 4     -- 编辑时按 Tab 键，插入 4 个空格
vim.opt.shiftwidth = 4      -- 自动缩进（>> 或 <<）时移动 4 个空格

vim.keymap.set({ "n", "v" }, "H", "^", { desc = "行首" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "行尾" })
vim.keymap.set({ "n", "v" }, "J", "<C-d>", { desc = "向下翻页" })
vim.keymap.set({ "n", "v" }, "K", "<C-u>", { desc = "向上翻页" })
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "去除高亮" })
vim.keymap.set("n", "<Space>w", "<Cmd>write<CR>", { desc = "保存" })
vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { desc = "关闭当前缓冲区" })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

vim.pack.add({
  'https://github.com/oneslash/helix-nvim',
})
vim.cmd.colorscheme('helix')
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


-- 1. 安装插件（bufferline 依赖 nvim-web-devicons 来显示图标）
vim.pack.add({
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

-- 2. 核心配置
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

vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
  -- 如果你想让状态栏显示图标，建议同时装上这个：
  'https://github.com/nvim-tree/nvim-web-devicons',
})
require('lualine').setup({
  options = {
    theme = 'auto', -- 或者直接写 'catppuccin'
    section_separators = { left = '█', right = '█' },
    component_separators = { left = '│', right = '│' },
    -- 你之前配的 Catppuccin 颜色应该会自动应用
    disabled_filetypes = {
        statusline = {"NvimTree"},  -- 删掉这里的 "NvimTree"
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'branch','filename','diagnostics'},
    lualine_x = {'diff','lsp_status',"location"},
    lualine_y = {},
    lualine_z = {}
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
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "blink.cmp"
       and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
    end
  end,
})
-- 3. 配置
require('blink.cmp').setup({
    keymap = { preset = 'enter' }, -- 或 'super-tab' 让 Tab 键接受补全
    appearance = { nerd_font_variant = 'mono' },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    -- 默认使用 Rust 匹配器；若无 Rust 环境可改为 "lua"
    fuzzy = { implementation = "prefer_rust" },
})


-- 安装官方 Zig 语法高亮插件（Codeberg 源）
vim.pack.add({
  'https://codeberg.org/ziglang/zig.vim',
})

-- 关闭 zig.vim 自带的保存时格式化（后面统一交给 ZLS 处理）
vim.g.zig_fmt_autosave = 0
vim.g.zig_fmt_parse_errors = 0

-- 配置 zls 客户端
vim.lsp.config['zls'] = {
  -- 如果 zls 不在 PATH 中，把 'zls' 换成 zls 可执行文件的绝对路径
  cmd = { 'zls' },
  filetypes = { 'zig', 'zon' },
  -- ZLS 通过项目根目录的 build.zig 来识别工作区
  root_markers = { 'build.zig' },
  settings = {
    zls = {
      -- 如果你把 zig 编译器放在了非标准路径，在这里指定
      -- zig_exe_path = '/path/to/zig',
    },
  },
}

-- 针对 zig 文件启用 zls
vim.lsp.enable('zls')

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.zig', '*.zon' },
  callback = function()
    vim.lsp.buf.format()
  end,
})

