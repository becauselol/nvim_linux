return {
	{
		"lervag/vimtex",
		ft = { "tex", "plaintex", "latex" },
		init = function()
			vim.g.vimtex_syntax_conceal_disable = 1
		vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_latexmk = {
				continuous = 0,
				out_dir = ".latex_output",
			}
			vim.api.nvim_create_autocmd("User", {
				pattern = "VimtexEventCompileSuccess",
				callback = function()
					local compiler = vim.b.vimtex and vim.b.vimtex.compiler
					if not compiler then return end
					local out_dir = compiler.out_dir or ".latex_output"
					local root = compiler.root or vim.fn.expand("%:p:h")
					local name = compiler.target_path
						and vim.fn.fnamemodify(compiler.target_path, ":t:r")
						or vim.fn.expand("%:t:r")
					local src = root .. "/" .. out_dir .. "/" .. name .. ".pdf"
					local dst = root .. "/" .. name .. ".pdf"
					vim.uv.fs_copyfile(src, dst, function(err)
						if err then
							vim.schedule(function()
								vim.notify("PDF copy failed: " .. err, vim.log.levels.WARN)
							end)
						end
					end)
				end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function(args)
					local ok, journal_cfg = pcall(require, "config.journal")
					if ok and journal_cfg.is_in_journal_buf and journal_cfg.is_in_journal_buf(args.buf) then
						return
					end
					local opts = { buffer = args.buf, silent = true, noremap = true }
					vim.keymap.set("n", "<leader>jc", "<cmd>VimtexCompile<cr>", vim.tbl_extend("force", opts, {
						desc = "LaTeX: Compile (latexmk)",
					}))
					vim.keymap.set("n", "<leader>jv", "<cmd>VimtexView<cr>", vim.tbl_extend("force", opts, {
						desc = "LaTeX: View PDF",
					}))
				end,
				desc = "LaTeX keymaps for non-journal .tex buffers",
			})
		end,
	},
}
