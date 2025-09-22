return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            -- Your gitsigns configuration options here
            signs = {
                add = {
                    hl = 'GitSignsAdd',
                    text = '+',
                    numhl='GitSignsAddNr',
                    linehl='GitSignsAddLn'
                },
                change = {
                    hl = 'GitSignsChange',
                    text = '│',
                    numhl='GitSignsChangeNr',
                    linehl='GitSignsChangeLn'
                },
                delete = {
                    hl = 'GitSignsDelete',
                    text = '✗',
                    numhl='GitSignsDeleteNr',
                    linehl='GitSignsDeleteLn'
                },
                topdelete = {
                    hl = 'GitSignsDelete',
                    text = '‾',
                    numhl='GitSignsDeleteNr',
                    linehl='GitSignsDeleteLn'
                },
                changedelete = {
                    hl = 'GitSignsChange',
                    text = '~',
                    numhl='GitSignsChangeNr',
                    linehl='GitSignsChangeLn'
                },
            },
        }
    end,
    whichkey = function(wk)

        local gitsigns = require('gitsigns')

        wk.add({
            {"<leader>h", group = "GitSigns"},
                -- Actions
            {'<leader>hs', gitsigns.stage_hunk, desc = 'Stage Hunk'},
            {'<leader>hr', gitsigns.reset_hunk, desc = 'Reset Hunk'},
            {'<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = 'v', desc = 'Stage Hunk'},
            {'<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, mode = 'v', desc = 'Reset Hunk'},
            {'<leader>hS', gitsigns.stage_buffer, desc = 'Stage Buffer'},
            {'<leader>hR', gitsigns.reset_buffer, desc = 'Reset Buffer'},
            {'<leader>hp', gitsigns.preview_hunk, desc = 'Preview Hunk'},
            {'<leader>hi', gitsigns.preview_hunk_inline, desc = 'Preview Hunk Inline'},
            {'<leader>hb', function() gitsigns.blame_line({ full = true }) end, desc = 'Blame Inline'},
            {'<leader>hd', gitsigns.diffthis, desc = 'Diff This'},
            {'<leader>hD', function() gitsigns.diffthis('~') end, desc = 'Diff This Tilda'},
            {'<leader>hQ', function() gitsigns.setqflist('all') end, desc = 'Diff Set qf List'},
            {'<leader>hq', gitsigns.setqflist, desc = ''},
            -- Toggles
            {'<leader>t', group = 'Toggle'},
            {'<leader>tb', gitsigns.toggle_current_line_blame, desc = 'Toggle Blame'},
            {'<leader>tw', gitsigns.toggle_word_diff, desc = 'Toggle Word Diff'},
        })
    end,
}
