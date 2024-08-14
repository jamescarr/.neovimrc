return {
    "akinsho/bufferline.nvim",

    config = function()
        require("bufferline").setup {
          options = {
            max_name_length = 3
          }
        }
    end

}
