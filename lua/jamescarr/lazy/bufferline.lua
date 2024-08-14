return {
    "akinsho/bufferline.nvim",

    config = function()
        local function limit_buffers(max_buffers)
            local buffers = vim.fn.getbufinfo({buflisted = 1})
            if #buffers > max_buffers then
                local oldest_buf = buffers[1].bufnr
                local oldest_time = buffers[1].lastused
                for i = 2, #buffers do
                    if buffers[i].lastused < oldest_time then
                        oldest_buf = buffers[i].bufnr
                        oldest_time = buffers[i].lastused
                    end
                end
                vim.api.nvim_buf_delete(oldest_buf, {force = true})
            end
        end

        vim.api.nvim_create_autocmd("BufAdd", {
            callback = function()
                vim.schedule(function()
                    limit_buffers(5)  -- Limit to 5 buffers
                end)
            end,
        })
        require("bufferline").setup {
          options = {
            max_name_length = 18
          }
        }
    end

}
