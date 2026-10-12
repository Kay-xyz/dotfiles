vim.pack.add({

	"https://github.com/catppuccin/nvim",
	"https://github.com/oneslash/helix-nvim",
})
vim.cmd.colorscheme("helix")
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#6c6999" })
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#281733" })

-- bufferline：被选中缓冲区的标题颜色
local bufferline_selected_hl = { fg = "#A4A0E8", bg = "#281733", bold = true }

local function apply_bufferline_selected_hl()
	vim.api.nvim_set_hl(0, "BufferLineBufferSelected", bufferline_selected_hl)
end

-- helix 自己定义了 BufferLineBufferSelected（apricot），而 bufferline 只以“默认值”方式注册
-- 高亮，所以配色一重新加载就会被盖掉。这里直接改掉 helix 的 bufferline 高亮表，
-- 之后每次加载 helix 都会带上这个颜色（即使是在 autocmd 里重新加载配色）。
pcall(function()
	local helix_bufferline = require("helix.groups.bufferline")
	local helix_highlight = helix_bufferline.highlight
	helix_bufferline.highlight = function(palette, opts)
		local groups = helix_highlight(palette, opts)
		groups.BufferLineBufferSelected = vim.deepcopy(bufferline_selected_hl)
		return groups
	end
end)

apply_bufferline_selected_hl()
-- 切到其它配色时也保持同样的颜色
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_bufferline_selected_hl })
