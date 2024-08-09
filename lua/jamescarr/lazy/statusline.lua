return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'nord'
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {
                  {
                    'filetype',
                    icon_only = true,
                  },
                  {
                    function()
                      local ts_utils = require('nvim-treesitter.ts_utils')
                      local node = ts_utils.get_node_at_cursor()
                      return node and node:type() or ''
                    end,
                    icon = '',
                  },
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
              }
        })
    end
}
