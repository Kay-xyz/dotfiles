-- flash.nvim：快速跳转
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
