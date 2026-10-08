vim.opt.number =true
vim.opt.relativenumber=false
vim.opt.fillchars = { eob = " " }
-- vim.opt.cursorline=true
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.expandtab = true    -- 关键：将 Tab 键输入转换为空格
vim.opt.tabstop = 4         -- 一个 Tab 字符显示为 4 个空格宽度
vim.opt.softtabstop = 4     -- 编辑时按 Tab 键，插入 4 个空格
vim.opt.shiftwidth = 4      -- 自动缩进（>> 或 <<）时移动 4 个空格
vim.opt.confirm=true


vim.keymap.set({ "n", "v" }, "H", "^", { desc = "行首" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "行尾" })
vim.keymap.set({ "n", "v" }, "J", "<C-d>", { desc = "向下翻页" })
vim.keymap.set({ "n", "v" }, "K", "<C-u>", { desc = "向上翻页" })
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "去除高亮" })
vim.keymap.set("n", "<Space>w", "<Cmd>write<CR>", { desc = "保存" })
vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { desc = "关闭当前缓冲区" })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "下一个缓冲区" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "上一个缓冲区" })

vim.pack.add({
  'https://github.com/catppuccin/nvim',
})
vim.cmd.colorscheme('catppuccin')
-- 设置一个明确的深色背景

vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig'
})
vim.lsp.enable('lua-language-server')

-- 自动pair
vim.pack.add({ "https://github.com/nvim-mini/mini.pairs" })
require("mini.pairs").setup()


-- flash
vim.pack.add({
  "https://github.com/folke/flash.nvim",
})

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
  'https://github.com/nvim-tree/nvim-web-devicons',
})
require('lualine').setup({
  options = {
    theme = 'auto',
    section_separators = { left = '█', right = '█' },
    component_separators = { left = '│', right = '│' },
    disabled_filetypes = {
        statusline = {"NvimTree"},
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
