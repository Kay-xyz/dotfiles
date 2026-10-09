local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.fillchars = { eob = " " }
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.expandtab = true -- 关键：将 Tab 键输入转换为空格
opt.tabstop = 4 -- 一个 Tab 字符显示为 4 个空格宽度
opt.softtabstop = 4 -- 编辑时按 Tab 键，插入 4 个空格
opt.shiftwidth = 4 -- 自动缩进（>> 或 <<）时移动 4 个空格
opt.confirm = true

-- 自动清理空的无名缓冲区
local function close_empty_unnamed_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if
			vim.api.nvim_buf_is_loaded(bufnr)
			and vim.api.nvim_buf_get_name(bufnr) == ""
			and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
		then
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local is_empty = #lines == 1 and lines[1] == ""
			local windows = vim.fn.win_findbuf(bufnr)

			-- 确保它不在任何窗口中显示，且未被修改
			if is_empty and #windows == 0 and not vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end
	end
end

-- 打开真实文件后触发清理
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = close_empty_unnamed_buffers,
})
