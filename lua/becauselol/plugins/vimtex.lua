return {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_view_method = 'chrome'
      vim.g.vimtex_view_general_viewer = 'chrome'
 --     vim.g.vimtex_compiler_method = 'xelatex'
      vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
--      vim.g.vimtex_compiler_latexmk_engines = {'_': '-xelatex',}
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
    end,
    ft = 'tex'
}
