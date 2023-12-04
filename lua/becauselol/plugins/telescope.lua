return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Fuzzy find files in cwd" })
      vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Fuzzy find files git"})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Fuzzy find open buffers"})
      vim.keymap.set('n', '<leader>fc', builtin.grep_string , { desc = "Find word under Cursor"})
      vim.keymap.set('n', '<leader>fs', builtin.live_grep , { desc = "Search for string"})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find help"})
  end
}
