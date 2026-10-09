local map = vim.keymap.set

map({ "n", "v" }, "H", "^", { desc = "行首" })
map({ "n", "v" }, "L", "$", { desc = "行尾" })
map({ "n", "v" }, "J", "<C-d>", { desc = "向下翻页" })
map({ "n", "v" }, "K", "<C-u>", { desc = "向上翻页" })
map("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "去除高亮" })
map("n", "<Space>w", "<Cmd>write<CR>", { desc = "保存" })
map("n", "q", "<Cmd>bdelete<CR>", { desc = "关闭当前缓冲区" })
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<S-l>", ":bnext<CR>", { desc = "下一个缓冲区" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "上一个缓冲区" })
map({ "n", "v" }, "gl", "$", { desc = "跳转到行尾" })
map({ "n", "v" }, "gh", "^", { desc = "跳转到行首" })
-- 使用 Ctrl + h/j/k/l 切换窗口
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口" })
