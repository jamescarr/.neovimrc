-- Global GitLab domain configuration
vim.g.fugitive_gitlab_domains = { "https://gitlab.com" }

local function fugitive_config()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git) -- Git status
    vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>") -- Git diffget left
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>") -- Git diffget right

    -- Augroup for Fugitive-specific commands
    local fugitive_augroup = vim.api.nvim_create_augroup("FugitiveConfig", { clear = true })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = fugitive_augroup,
        pattern = "*",
        callback = function()
            if vim.bo.filetype ~= "fugitive" then
                return
            end

            local bufnr = vim.api.nvim_get_current_buf()
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "<leader>p", function()
                vim.cmd.Git("push")
            end, opts)

            vim.keymap.set("n", "<leader>P", function()
                vim.cmd.Git({ "pull", "--rebase" })
            end, opts)

            vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts) -- Track remote branch
        end,
    })
end

local function gitlab_config()
    vim.keymap.set("n", "<leader>gb", vim.cmd.GBrowse) -- Open in GitLab
end

return {
    {
        "tpope/vim-fugitive",
        config = fugitive_config,
    },
    {
        "shumphrey/fugitive-gitlab.vim",
        config = gitlab_config,
    },
}
