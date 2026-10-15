-- telescope：模糊查找
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if
            ev.data.spec.name == "telescope-fzf-native.nvim"
            and (ev.data.kind == "install" or ev.data.kind == "update")
        then
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
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

vim.keymap.set("n", "<space><space>", builtin.find_files, { desc = "查找文件" })
vim.keymap.set('n', '<space>/', builtin.live_grep, { desc = '全局搜索文件内容' })

-- git 改动文件列表：Tab / Shift-Tab 多选，Enter 一次打开所有选中项（没多选就打开当前项）
-- 注意：git_status 默认把 Tab 绑成「暂存/取消暂存」，这里覆盖回多选；
-- 如果想保留暂存功能，告诉我，我把它换到别的键
vim.keymap.set("n", "<Space>gs", function()
	builtin.git_status({
		attach_mappings = function(prompt_bufnr, map)
			-- 多选并移动（覆盖内置的 Tab = staging）
			map({ "i", "n" }, "<Tab>", actions.toggle_selection + actions.move_selection_worse)
			map({ "i", "n" }, "<S-Tab>", actions.toggle_selection + actions.move_selection_better)

			-- Enter：打开所有选中项；没多选时退回默认打开当前项
			map({ "i", "n" }, "<CR>", function()
				local picker = action_state.get_current_picker(prompt_bufnr)
				local multi = picker:get_multi_selection()
				local targets = #multi > 0 and multi or { action_state.get_selected_entry() }
				actions.close(prompt_bufnr)
				for _, entry in ipairs(targets) do
					if entry and entry.path then
						vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
					end
				end
			end)
			return true
		end,
	})
end, { desc = "git 改动列表（Tab 多选，Enter 一起打开）" })
