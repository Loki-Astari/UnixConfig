return {
    'Loki-Astari/cursor',
    config = function()
        require('cursor').setup({
            width = 50,                 -- Width of the cursor window (default: 50)
            auto_open = false,          -- Auto-open on startup (default: false)
            command = 'cursor-agent',
            -- highlight = 'CursorAgentSidebar',
            -- auto_close_on_exit = true,
        })
    end,
    whichkey = function(wk)
        wk.add({
            {'<leader>c', group = 'Cursor'},
            {'<leader>ca', ':CursorOpen<CR>',   desc = 'Open (if needed), Switch to Cursor Window'},
            {'<leader>cc', ':CursorClose<CR>',  desc = 'Close Cursor Window'},
            {'<leader>ct', ':CursorToggle<CR>', desc = 'Toggle Cursor Window'},
        })
    end,
}

