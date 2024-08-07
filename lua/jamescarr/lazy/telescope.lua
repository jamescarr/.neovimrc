return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                  -- Elixir
                  "_build",
                  "deps",
                  -- Node.js
                  "node_modules",
                  -- Go
                  "bin",
                  "pkg",
                  -- Python
                  "__pycache__",
                  "env",
                  "venv",
                  ".venv",
                  "dist",
                  "build",
                  "*.egg-info",
                }
            }
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        -- map `gr` (go to reference) to open in telescope!
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', {noremap=true, silent=true})
    end
}

