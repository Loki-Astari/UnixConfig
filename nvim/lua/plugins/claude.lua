x=  {
    'greggh/claude-code.nvim',
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
        require("claude-code").setup({
            command = "claude",
            -- Conversation management
            continue = "--continue", -- Resume the most recent conversation
            resume = "--resume",     -- Display an interactive conversation picker
            verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
            window = {
                split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
                position = "right",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
                enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
                hide_numbers = true,    -- Hide line numbers in the terminal window
                hide_signcolumn = true, -- Hide the sign column in the terminal window
            },
            refresh = {
                enable = true,
                updatetime = 100,
                timer_interval = 1000,
                show_notifications = true
            },
            git = {
                use_git_root = true,
            },
        })
    end,
    whichkey = function(wk)
        wk.add({
            {'<leader>a', group = 'AI'},
            {'<leader>aC', group = 'Claude'},
            {'<leader>aCa', ':ClaudeCode<CR>',   desc = 'Open (if needed), Switch to Cursor Window'}
        })
    end
}

return {
    dir = "~/Repo/Claude/claude.nvim",
    config = function()
      require("claude").setup({
        width = 0.4,  -- 40% of screen width (or use integers for columns)
        command = "claude",
      })
    end,
}


