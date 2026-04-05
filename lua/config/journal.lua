local M = {}

-- Add journal directories here. Only buffers inside these roots get journal commands/keymaps.
M.journal_dirs = {
	vim.fn.expand("~/Documents/journal-notes"),
	vim.fn.expand("~/Documents/Research/2025-09-JacqWang-Microtransit/journal-notes"),
	-- vim.fn.expand("~/Documents/another-journal"),
}

local journal = require("journal")

local function realpath(path)
	if not path or path == "" then
		return nil
	end
	return vim.loop.fs_realpath(path) or path
end

function M.is_in_journal_buf(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname == "" then
		return nil
	end
	local file_path = realpath(bufname)
	if not file_path then
		return nil
	end
	for _, dir in ipairs(M.journal_dirs) do
		local root = realpath(dir)
		if root and file_path:sub(1, #root) == root then
			return root
		end
	end
	return nil
end

function M.is_in_journal_cwd()
	local cwd = realpath(vim.fn.getcwd())
	if not cwd then
		return nil
	end
	for _, dir in ipairs(M.journal_dirs) do
		local root = realpath(dir)
		if root and cwd:sub(1, #root) == root then
			return root
		end
	end
	return nil
end

local instances = {}

local function get_instance(root)
	if not instances[root] then
		instances[root] = journal.new(root)
	end
	return instances[root]
end

local function set_journal_keymaps(j)
	local opts = { silent = true, noremap = true }
	vim.keymap.set("n", "<leader>jt", function()
		j.open_today()
	end, vim.tbl_extend("force", opts, { desc = "Today's note" }))
	vim.keymap.set("n", "<leader>jd", function()
		j.open_date()
	end, vim.tbl_extend("force", opts, { desc = "Note by date" }))
	vim.keymap.set("n", "<leader>jc", function()
		j.compile_notes()
	end, vim.tbl_extend("force", opts, { desc = "Compile notes" }))
	vim.keymap.set("n", "<leader>jv", function()
		j.view_notes_zathura()
	end, vim.tbl_extend("force", opts, { desc = "View notes (zathura)" }))
	vim.keymap.set("n", "<leader>jgm", function()
		j.open_goals("month")
	end, vim.tbl_extend("force", opts, { desc = "Monthly goals" }))
	vim.keymap.set("n", "<leader>jgy", function()
		j.open_goals("year")
	end, vim.tbl_extend("force", opts, { desc = "Yearly goals" }))
	vim.keymap.set("n", "<leader>jrm", function()
		j.open_results("month")
	end, vim.tbl_extend("force", opts, { desc = "Monthly results" }))
	vim.keymap.set("n", "<leader>jry", function()
		j.open_results("year")
	end, vim.tbl_extend("force", opts, { desc = "Yearly results" }))
	vim.keymap.set("n", "<leader>jac", function()
		j.compile_archive()
	end, vim.tbl_extend("force", opts, { desc = "Compile archive" }))
	vim.keymap.set("n", "<leader>jav", function()
		j.view_archive()
	end, vim.tbl_extend("force", opts, { desc = "View archive" }))
	vim.keymap.set("n", "<leader>jm", function()
		j.update_master()
	end, vim.tbl_extend("force", opts, { desc = "Update master" }))
end

local function set_journal_commands(j)
	vim.api.nvim_create_user_command("NoteToday", function()
		j.open_today()
	end, { desc = "Open today's note" })

	vim.api.nvim_create_user_command("NoteDate", function(opts)
		j.open_date(opts.args ~= "" and opts.args or nil)
	end, { desc = "Open note for specific date", nargs = "?" })

	vim.api.nvim_create_user_command("NotesCompile", function()
		j.compile_notes()
	end, { desc = "Compile notes to PDF" })

	vim.api.nvim_create_user_command("NotesView", function()
		j.view_notes()
	end, { desc = "View compiled notes" })

	vim.api.nvim_create_user_command("NotesViewZathura", function()
		j.view_notes_zathura()
	end, { desc = "View notes in Zathura (auto-reloads)" })

	vim.api.nvim_create_user_command("MasterUpdate", function()
		j.update_master()
	end, { desc = "Update master document" })

	vim.api.nvim_create_user_command("GoalsMonth", function()
		j.open_goals("month")
	end, { desc = "Open monthly goals" })

	vim.api.nvim_create_user_command("GoalsYear", function()
		j.open_goals("year")
	end, { desc = "Open yearly goals" })

	vim.api.nvim_create_user_command("ResultsMonth", function()
		j.open_results("month")
	end, { desc = "Open monthly results" })

	vim.api.nvim_create_user_command("ResultsYear", function()
		j.open_results("year")
	end, { desc = "Open yearly results" })

	vim.api.nvim_create_user_command("ArchiveCompile", function()
		j.compile_archive()
	end, { desc = "Compile archive" })

	vim.api.nvim_create_user_command("ArchiveView", function()
		j.view_archive()
	end, { desc = "View archive" })
end

local active_root = nil
local function detach_journal()
	if not active_root then
		return
	end
	for _, lhs in ipairs({
		"<leader>jt",
		"<leader>jd",
		"<leader>jc",
		"<leader>jv",
		"<leader>jgm",
		"<leader>jgy",
		"<leader>jrm",
		"<leader>jry",
		"<leader>jac",
		"<leader>jav",
		"<leader>jm",
	}) do
		pcall(vim.keymap.del, "n", lhs)
	end
	for _, cmd in ipairs({
		"NoteToday",
		"NoteDate",
		"NotesCompile",
		"NotesView",
		"NotesViewZathura",
		"MasterUpdate",
		"GoalsMonth",
		"GoalsYear",
		"ResultsMonth",
		"ResultsYear",
		"ArchiveCompile",
		"ArchiveView",
	}) do
		pcall(vim.api.nvim_del_user_command, cmd)
	end
	active_root = nil
end

local function attach_if_journal(bufnr)
	local root = M.is_in_journal_buf(bufnr) or M.is_in_journal_cwd()
	if not root then
		detach_journal()
		return
	end
	if active_root == root then
		return
	end
	detach_journal()
	local j = get_instance(root)
	set_journal_commands(j)
	set_journal_keymaps(j)
	active_root = root
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter", "DirChanged" }, {
	callback = function(args)
		attach_if_journal(args.buf or vim.api.nvim_get_current_buf())
	end,
	desc = "Journal commands/keymaps (only inside journal directories)",
})

return M
