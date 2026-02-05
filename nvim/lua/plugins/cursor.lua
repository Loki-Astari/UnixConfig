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
            {'<leader>a', group = 'AI'},
            {'<leader>ac', group = 'Cursor'},
            {'<leader>aca', ':CursorOpen<CR>',   desc = 'Open (if needed), Switch to Cursor Window'},
            {'<leader>acc', ':CursorClose<CR>',  desc = 'Close Cursor Window'},
            {'<leader>act', ':CursorToggle<CR>', desc = 'Toggle Cursor Window'},
        })
    end,
}

