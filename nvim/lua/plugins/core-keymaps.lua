local function show_keybindings()
    local path = vim.fn.stdpath('config') .. '/doc/keybindings.md'
    local lines = vim.fn.readfile(path)
    if #lines == 0 then
        vim.notify('Keybindings doc not found', vim.log.levels.WARN)
        return
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'markdown'

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = ' Keybindings ',
        title_pos = 'center',
    })

    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
    vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
end

local copy_mode = {
    active = false,
    saved_number = nil,
    saved_relativenumber = nil,
    saved_signcolumn = nil,
    saved_win = nil,
    agent_was_open = false,
}

local function toggle_copy_mode()
    if not copy_mode.active then
        local win = vim.api.nvim_get_current_win()
        copy_mode.saved_win = win
        copy_mode.saved_number = vim.api.nvim_get_option_value('number', { win = win })
        copy_mode.saved_relativenumber = vim.api.nvim_get_option_value('relativenumber', { win = win })
        copy_mode.saved_signcolumn = vim.api.nvim_get_option_value('signcolumn', { win = win })

        vim.api.nvim_set_option_value('number', false, { win = win })
        vim.api.nvim_set_option_value('relativenumber', false, { win = win })
        vim.api.nvim_set_option_value('signcolumn', 'no', { win = win })

        local ok, aiagent = pcall(require, 'aiagent')
        if ok and aiagent.is_open() then
            copy_mode.agent_was_open = true
            aiagent.toggle()
        else
            copy_mode.agent_was_open = false
        end

        copy_mode.active = true
        vim.notify('Copy Mode ON', vim.log.levels.INFO)
    else
        local win = copy_mode.saved_win
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value('number', copy_mode.saved_number, { win = win })
            vim.api.nvim_set_option_value('relativenumber', copy_mode.saved_relativenumber, { win = win })
            vim.api.nvim_set_option_value('signcolumn', copy_mode.saved_signcolumn, { win = win })
        end

        if copy_mode.agent_was_open then
            local ok, aiagent = pcall(require, 'aiagent')
            if ok then
                aiagent.toggle()
            end
        end

        copy_mode.active = false
        copy_mode.agent_was_open = false
        copy_mode.saved_win = nil
        vim.notify('Copy Mode OFF', vim.log.levels.INFO)
    end
end

return {
    dir = vim.fn.stdpath('config'),
    name = 'core-keymaps',
    whichkey = function(wk)
        wk.add({
            -- Buffer jump by position
            {'<leader>0', group = "Switch Buffer"},
            {'<leader>01', '<cmd>BufferLineGoToBuffer 1<CR>',  desc = 'Buffer 1'},
            {'<leader>02', '<cmd>BufferLineGoToBuffer 2<CR>',  desc = 'Buffer 2'},
            {'<leader>03', '<cmd>BufferLineGoToBuffer 3<CR>',  desc = 'Buffer 3'},
            {'<leader>04', '<cmd>BufferLineGoToBuffer 4<CR>',  desc = 'Buffer 4'},
            {'<leader>05', '<cmd>BufferLineGoToBuffer 5<CR>',  desc = 'Buffer 5'},
            {'<leader>06', '<cmd>BufferLineGoToBuffer 6<CR>',  desc = 'Buffer 6'},
            {'<leader>07', '<cmd>BufferLineGoToBuffer 7<CR>',  desc = 'Buffer 7'},
            {'<leader>08', '<cmd>BufferLineGoToBuffer 8<CR>',  desc = 'Buffer 8'},
            {'<leader>09', '<cmd>BufferLineGoToBuffer 9<CR>',  desc = 'Buffer 9'},
            {'<leader>0$', '<cmd>BufferLineGoToBuffer -1<CR>', desc = 'Last Buffer'},

            -- Buffer pick
            {'<leader>b',  group = 'Buffer'},
            {'<leader>bp', '<cmd>BufferLinePick<CR>',      desc = 'Pick Buffer'},
            {'<leader>bx', '<cmd>BufferLinePickClose<CR>', desc = 'Pick Close Buffer'},

            -- Quickfix
            {'<leader>E', '<cmd>copen<CR>', desc = 'Open Quickfix (errors)'},

            -- Copy Mode
            {'<leader>q',  group = 'Copy Mode'},
            {'<leader>qq', toggle_copy_mode, desc = 'Toggle Copy Mode'},

            -- Config reload
            {'<leader>r',  group = 'Config'},
            {'<leader>K', show_keybindings, desc = 'Show Keybindings'},

            {'<leader>rr', function()
                dofile(vim.fn.stdpath('config') .. '/lua/core/options.lua')
                dofile(vim.fn.stdpath('config') .. '/lua/core/keymaps.lua')
                vim.notify('Config reloaded', vim.log.levels.INFO)
            end, desc = 'Reload Config'},
        })
    end,
}
