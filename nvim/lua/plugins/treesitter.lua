
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
        ensure_installed = {
            'bash',
            'c',
            'cpp',
            'diff',
            'dockerfile',
            'gitignore',
            'html',
            'java',
            'javascript',
            'json',
            'lua',
            'luadoc',
            'make',
            'markdown',
            'markdown_inline',
            'python',
            'terraform',
            'toml',
            'typescript',
            'query',
            'vim',
            'vimdoc',
            'yaml'
        },
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = { enable = true, disable = { 'ruby', 'cpp' } },
    },
}

