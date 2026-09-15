return {
    'Loki-Astari/gauntlet.nvim',
    config = function()
      require("gauntlet").setup({})
    end,
    whichkey = function(wk)

        wk.add({
            {"<leader>G", group = "Gauntlet"},

            -- Starting a review.
            {'<leader>GG', '<cmd>Gauntlet<cr>', desc = 'List open pull requests'},
            {'<leader>Go', function()
                vim.ui.input({ prompt = 'Pull request (number or URL): ' }, function(answer)
                    if answer and vim.trim(answer) ~= '' then
                        require('gauntlet').review(answer)
                    end
                end)
            end, desc = 'Review a pull request by number'},
            {'<leader>Gr', '<cmd>GauntletRefresh<cr>', desc = 'Refresh: new commits and threads'},

            -- Sending comments and a verdict.  Lower case p pushes comments,
            -- upper case P publishes code; the two are deliberately a pair.
            {'<leader>Gp', '<cmd>GauntletPush<cr>',    desc = 'Push new comments'},
            {'<leader>Gn', '<cmd>GauntletNote<cr>',    desc = 'Note on the PR as a whole'},
            {'<leader>Gs', '<cmd>GauntletSubmit<cr>',  desc = 'Submit: choose a verdict'},
            {'<leader>Ga', '<cmd>GauntletApprove<cr>', desc = 'Approve'},
            -- Not <leader>GR: rejecting a pull request by fumbling a refresh
            -- is not a mistake worth making possible.
            {'<leader>Gx', '<cmd>GauntletReject<cr>',  desc = 'Reject: request changes'},

            -- Answering a review of your own.
            {'<leader>Gc', '<cmd>GauntletCommit<cr>',  desc = 'Commit the review worktree'},
            {'<leader>GP', '<cmd>GauntletPublish<cr>', desc = 'Publish: push onto the PR branch'},

            -- Upper case, being the one that throws work away.
            {'<leader>GD', '<cmd>GauntletDiscard<cr>', desc = 'Discard this review from disk'},
        })

    end,
}
