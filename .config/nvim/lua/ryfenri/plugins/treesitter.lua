return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup({})

            local languages = {
                "c",
                "cpp",
                "rust",
                "go",
                "lua",
                "vim",
                "vimdoc",
                "markdown",
                "markdown_inline",
                "python",
                "typescript",
                "javascript",
                "astro",
            }

            require("nvim-treesitter").install(languages)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = languages,
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {},
    },
}
