return {
    'Loki-Astari/cursor',
    config = function()
        -- Stuff
    end,
    whichkey = function(wk)
        wk.add({
            {'<leader>sc', ':set ic!<CR>',   desc = 'Toggle case sensative search'}
        })
    end,
}

