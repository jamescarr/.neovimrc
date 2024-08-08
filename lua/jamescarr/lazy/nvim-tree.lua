return {
    "nvim-tree/nvim-tree.lua",

    tag = "",

    config = function()
        -- load and setup nvim-tree
        require("nvim-tree").setup(
            vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
        )
        -- Automatically open nvim-tree when starting Neovim
        vim.api.nvim_create_autocmd('VimEnter', {
            callback = function()
                require('nvim-tree.api').tree.open()
            end
        })
    end

}
