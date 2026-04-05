-- Journal Notes Lua Module for Neovim (config-local copy)
-- Provides journal commands for a configurable journal directory.

local Journal = {}

function Journal.new(base_dir)
	local M = {}

	-- Get the base directory (root of journal-notes repo)
	M.base_dir = base_dir
	M.notes_dir = M.base_dir .. "/notes"
	M.scripts_dir = M.base_dir .. "/scripts"

	-- Month names for display
	local month_names = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	}

	-- Helper: Get formatted date parts
	local function get_date_parts(date_str)
		local year, month, day
		if date_str then
			year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
		else
			year = os.date("%Y")
			month = os.date("%m")
			day = os.date("%d")
		end
		return year, month, day
	end

	-- Helper: Get display date (e.g., "January 21, 2026")
	local function get_display_date(year, month, day)
		local month_num = tonumber(month)
		local month_name = month_names[month_num] or month
		return string.format("%s %s, %s", month_name, day, year)
	end

	-- Helper: Ensure directory exists
	local function ensure_dir(path)
		vim.fn.mkdir(path, "p")
	end

	-- Helper: Check if file exists
	local function file_exists(path)
		return vim.fn.filereadable(path) == 1
	end

	-- Helper: Write template to file if it doesn't exist
	local function write_template(path, content)
		if not file_exists(path) then
			local file = io.open(path, "w")
			if file then
				file:write(content)
				file:close()
				return true
			end
		end
		return false
	end

	local function output_dir()
		return M.notes_dir .. "/.latex_output"
	end

	local function ensure_output_dir()
		ensure_dir(output_dir())
	end

	-- Open today's note
	function M.open_today()
		local year, month, day = get_date_parts()
		local display_date = get_display_date(year, month, day)

		local note_dir = string.format("%s/%s/%s/%s", M.notes_dir, year, month, day)
		local note_file = note_dir .. "/note.tex"

		ensure_dir(note_dir)

		local template = string.format(
			[[
\section{%s}

%% Your notes for today


]],
			display_date
		)

		local created = write_template(note_file, template)
		if created then
			vim.notify("Created new note for " .. display_date, vim.log.levels.INFO)
		end

		vim.cmd("edit " .. note_file)
	end

	-- Open note for specific date (prompts user)
	function M.open_date(date_str)
		if not date_str or date_str == "" then
			vim.ui.input({ prompt = "Enter date (YYYY-MM-DD): " }, function(input)
				if input and input ~= "" then
					M.open_date(input)
				end
			end)
			return
		end

		-- Validate date format
		local year, month, day = date_str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
		if not year then
			vim.notify("Invalid date format. Use YYYY-MM-DD", vim.log.levels.ERROR)
			return
		end

		local display_date = get_display_date(year, month, day)
		local note_dir = string.format("%s/%s/%s/%s", M.notes_dir, year, month, day)
		local note_file = note_dir .. "/note.tex"

		ensure_dir(note_dir)

		local template = string.format(
			[[
\section{%s}

%% Your notes for %s


]],
			display_date,
			date_str
		)

		local created = write_template(note_file, template)
		if created then
			vim.notify("Created new note for " .. display_date, vim.log.levels.INFO)
		else
			vim.notify("Opening existing note for " .. display_date, vim.log.levels.INFO)
		end

		vim.cmd("edit " .. note_file)
	end

	-- Open goals file
	function M.open_goals(period)
		local year = os.date("%Y")
		local month = os.date("%m")
		local month_name = month_names[tonumber(month)]

		local goals_file, template

		if period == "year" or period == "yearly" then
			local goals_dir = string.format("%s/%s", M.notes_dir, year)
			ensure_dir(goals_dir)
			goals_file = goals_dir .. "/goals.tex"

			template = string.format(
				[[
\section*{%s Goals}

%% Your yearly goals for %s

\begin{enumerate}
    \item
\end{enumerate}
]],
				year,
				year
			)
		else
			local goals_dir = string.format("%s/%s/%s", M.notes_dir, year, month)
			ensure_dir(goals_dir)
			goals_file = goals_dir .. "/goals.tex"

			template = string.format(
				[[
\subsection*{%s %s Goals}

%% Your monthly goals for %s %s

\begin{enumerate}
    \item
\end{enumerate}
]],
				month_name,
				year,
				month_name,
				year
			)
		end

		write_template(goals_file, template)
		vim.cmd("edit " .. goals_file)
	end

	-- Open results file
	function M.open_results(period)
		local year = os.date("%Y")
		local month = os.date("%m")
		local month_name = month_names[tonumber(month)]

		local results_file, template

		if period == "year" or period == "yearly" then
			local results_dir = string.format("%s/%s", M.notes_dir, year)
			ensure_dir(results_dir)
			results_file = results_dir .. "/results.tex"

			template = string.format(
				[[
\section*{%s Results}

%% Review of your %s goals at year end

\begin{enumerate}
    \item
\end{enumerate}
]],
				year,
				year
			)
		else
			local results_dir = string.format("%s/%s/%s", M.notes_dir, year, month)
			ensure_dir(results_dir)
			results_file = results_dir .. "/results.tex"

			template = string.format(
				[[
\subsection*{%s %s Results}

%% Review of your %s %s goals at month end

\begin{enumerate}
    \item
\end{enumerate}
]],
				month_name,
				year,
				month_name,
				year
			)
		end

		write_template(results_file, template)
		vim.cmd("edit " .. results_file)
	end

	-- Compile notes (calls shell script - complex logic)
	function M.compile_notes()
		vim.notify("Compiling notes...", vim.log.levels.INFO)
		ensure_output_dir()
		vim.fn.jobstart({
			"latexmk",
			"-pdf",
			"-interaction=nonstopmode",
			"-outdir=" .. output_dir(),
			"master.tex",
		}, {
			cwd = M.notes_dir,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("Notes compiled successfully!", vim.log.levels.INFO)
				else
					vim.notify("Failed to compile notes", vim.log.levels.ERROR)
				end
			end,
			on_stdout = function(_, data)
				for _, line in ipairs(data) do
					if line ~= "" then
						print(line)
					end
				end
			end,
			on_stderr = function(_, data)
				for _, line in ipairs(data) do
					if line ~= "" then
						print(line)
					end
				end
			end,
		})
	end

	-- View compiled notes
	function M.view_notes()
		local pdf_file = output_dir() .. "/master.pdf"
		if not file_exists(pdf_file) then
			vim.notify("No compiled PDF found. Compiling first...", vim.log.levels.WARN)
			M.compile_notes()
			return
		end
		vim.fn.jobstart({ "xdg-open", pdf_file }, { detach = true })
	end

	-- Track if zathura is already running for this session
	M.zathura_pid = nil

	-- Helper to launch zathura
	local function launch_zathura(pdf_file)
		local job_id = vim.fn.jobstart({ "zathura", pdf_file }, {
			detach = true,
			on_exit = function()
				M.zathura_pid = nil
			end,
		})

		if job_id > 0 then
			vim.defer_fn(function()
				local handle = io.popen("pgrep -n zathura")
				if handle then
					local pid = handle:read("*a"):gsub("%s+", "")
					handle:close()
					if pid ~= "" then
						M.zathura_pid = pid
						vim.notify("Zathura opened (use Super+Right to snap to right side)", vim.log.levels.INFO)
					end
				end
			end, 500)
		end
	end

	-- Compile notes with optional callback when done
	function M.compile_notes_with_callback(on_success)
		vim.notify("Compiling notes...", vim.log.levels.INFO)
		ensure_output_dir()
		vim.fn.jobstart({
			"latexmk",
			"-pdf",
			"-interaction=nonstopmode",
			"-outdir=" .. output_dir(),
			"master.tex",
		}, {
			cwd = M.notes_dir,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("Notes compiled successfully!", vim.log.levels.INFO)
					if on_success then
						on_success()
					end
				else
					vim.notify("Failed to compile notes", vim.log.levels.ERROR)
				end
			end,
		})
	end

	-- View notes with zathura (auto-reloads on PDF change)
	function M.view_notes_zathura()
		local pdf_file = output_dir() .. "/master.pdf"

		-- Check if zathura is already running with our PDF
		if M.zathura_pid then
			-- Check if process is still alive
			local handle = io.popen("ps -p " .. M.zathura_pid .. " > /dev/null 2>&1 && echo 'running'")
			if handle then
				local result = handle:read("*a")
				handle:close()
				if result:find("running") then
					vim.notify("Zathura already open (PID: " .. M.zathura_pid .. ")", vim.log.levels.INFO)
					return
				end
			end
		end

		if not file_exists(pdf_file) then
			vim.notify("No compiled PDF found. Compiling first...", vim.log.levels.WARN)
			-- Compile and open zathura only after compilation succeeds
			M.compile_notes_with_callback(function()
				launch_zathura(pdf_file)
			end)
			return
		end

		launch_zathura(pdf_file)
	end

	-- Compile on save functionality
	function M.compile_on_save()
		vim.notify("Compiling notes...", vim.log.levels.INFO)
		ensure_output_dir()
		vim.fn.jobstart({
			"latexmk",
			"-pdf",
			"-interaction=nonstopmode",
			"-outdir=" .. output_dir(),
			"master.tex",
		}, {
			cwd = M.notes_dir,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("Notes compiled!", vim.log.levels.INFO)
				else
					vim.notify("Compile failed", vim.log.levels.ERROR)
				end
			end,
		})
	end

	-- Setup autocommand for compile on save
	function M.setup_auto_compile()
		local group = vim.api.nvim_create_augroup("JournalAutoCompile", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = group,
			pattern = M.notes_dir .. "/**/*.tex",
			callback = function()
				M.compile_on_save()
			end,
			desc = "Auto-compile journal notes on save",
		})
		vim.notify("Auto-compile enabled for .tex files", vim.log.levels.INFO)
	end

	-- Disable auto-compile
	function M.disable_auto_compile()
		vim.api.nvim_del_augroup_by_name("JournalAutoCompile")
		vim.notify("Auto-compile disabled", vim.log.levels.INFO)
	end

	-- Update master document (calls shell script)
	function M.update_master()
		vim.notify("Updating master document...", vim.log.levels.INFO)
		vim.fn.jobstart(M.scripts_dir .. "/update-master.sh", {
			cwd = M.notes_dir,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("Master document updated!", vim.log.levels.INFO)
				else
					vim.notify("Failed to update master document", vim.log.levels.ERROR)
				end
			end,
		})
	end

	-- Compile archive with optional callback (first updates archive.tex, then compiles)
	function M.compile_archive(on_success)
		vim.notify("Updating archive document...", vim.log.levels.INFO)
		ensure_output_dir()
		-- First run update-archive.sh to populate archive.tex with all notes
		vim.fn.jobstart(M.scripts_dir .. "/update-archive.sh", {
			cwd = M.notes_dir,
			on_exit = function(_, update_code)
				if update_code ~= 0 then
					vim.notify("Failed to update archive.tex", vim.log.levels.ERROR)
					return
				end
				vim.notify("Archive updated, compiling...", vim.log.levels.INFO)
				vim.fn.jobstart({
					"latexmk",
					"-pdf",
					"-interaction=nonstopmode",
					"-outdir=" .. output_dir(),
					"archive.tex",
				}, {
					cwd = M.notes_dir,
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Archive compiled successfully!", vim.log.levels.INFO)
							if on_success then
								on_success()
							end
						else
							vim.notify("Failed to compile archive", vim.log.levels.ERROR)
						end
					end,
				})
			end,
		})
	end

	-- Track if zathura is already running for archive
	M.archive_zathura_pid = nil

	-- Helper to launch zathura for archive
	local function launch_archive_zathura(pdf_file)
		local job_id = vim.fn.jobstart({ "zathura", pdf_file }, {
			detach = true,
			on_exit = function()
				M.archive_zathura_pid = nil
			end,
		})
		if job_id > 0 then
			vim.defer_fn(function()
				local handle = io.popen("pgrep -n zathura")
				if handle then
					local pid = handle:read("*a"):gsub("%s+", "")
					handle:close()
					if pid ~= "" then
						M.archive_zathura_pid = pid
					end
				end
			end, 500)
		end
	end

	-- View archive with zathura (auto-reloads on PDF change)
	function M.view_archive()
		local pdf_file = output_dir() .. "/archive.pdf"

		-- Check if zathura is already running with our archive PDF
		if M.archive_zathura_pid then
			local handle = io.popen("ps -p " .. M.archive_zathura_pid .. " > /dev/null 2>&1 && echo 'running'")
			if handle then
				local result = handle:read("*a")
				handle:close()
				if result:find("running") then
					vim.notify("Archive viewer already open (PID: " .. M.archive_zathura_pid .. ")", vim.log.levels.INFO)
					return
				end
			end
		end

		if not file_exists(pdf_file) then
			vim.notify("No compiled archive found. Compiling first...", vim.log.levels.WARN)
			M.compile_archive(function()
				launch_archive_zathura(pdf_file)
			end)
			return
		end

		launch_archive_zathura(pdf_file)
	end

	return M
end

return Journal
