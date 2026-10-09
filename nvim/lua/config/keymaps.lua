local map = vim.keymap.set

map({ "n", "v" }, "H", "^", { desc = "行首" })
map({ "n", "v" }, "L", "$", { desc = "行尾" })
map({ "n", "v" }, "J", "<C-d>", { desc = "向下翻页" })
map({ "n", "v" }, "K", "<C-u>", { desc = "向上翻页" })
map("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "去除高亮" })
map("n", "<Space>w", "<Cmd>write<CR>", { desc = "保存" })
map("n", "q", "<Cmd>bdelete<CR>", { desc = "关闭当前缓冲区" })
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "下一个缓冲区" })
map("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "上一个缓冲区" })
map({ "n", "v" }, "gl", "$", { desc = "跳转到行尾" })
map({ "n", "v" }, "gh", "^", { desc = "跳转到行首" })
