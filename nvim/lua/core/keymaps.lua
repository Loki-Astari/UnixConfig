
-- Key map command
-- vim.keymap.set(<Mode>, <Key Combinaition>, <Cmd>, <Options>)
--      Mode:   Either a single letter or a list of letters.
--          n:      Normal mode
--          v:      visual
--      Key:
--          <C-X>   Control Key mapping:    Control Capitol X here. Should be quoted. Include the '<>'
--          <Space> Space Key
--          <leader><Key Sequence>
--      Cmd:
--          <Nop>                           Nothing.
--          <cmd><String with vim command>  Execute a standard vim command.
--      Options:
--          Set of optional options.


-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable space standard operation.
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true})

-- Get the opts
local opts = {noremap = true, silent = true}

-- Moving through code keeps text centered vertically.
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Re-sizing Window
vim.keymap.set('n', '<S-Up>',   ':resize -2<CR>', opts)
vim.keymap.set('n', '<S-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<S-Right>',':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<S-Left>', ':vertical resize +2<CR>', opts)

-- Moving between buffers
vim.keymap.set('n', '<Tab>',      ':bnext<CR>',     opts)
vim.keymap.set('n', '<S-Tab>',    ':bprevious<CR>', opts)

-- Jump to buffer by position (matches ordinal number shown on tab)
vim.keymap.set('n', '<leader>1',  '<cmd>BufferLineGoToBuffer 1<CR>', opts)
vim.keymap.set('n', '<leader>2',  '<cmd>BufferLineGoToBuffer 2<CR>', opts)
vim.keymap.set('n', '<leader>3',  '<cmd>BufferLineGoToBuffer 3<CR>', opts)
vim.keymap.set('n', '<leader>4',  '<cmd>BufferLineGoToBuffer 4<CR>', opts)
vim.keymap.set('n', '<leader>5',  '<cmd>BufferLineGoToBuffer 5<CR>', opts)
vim.keymap.set('n', '<leader>6',  '<cmd>BufferLineGoToBuffer 6<CR>', opts)
vim.keymap.set('n', '<leader>7',  '<cmd>BufferLineGoToBuffer 7<CR>', opts)
vim.keymap.set('n', '<leader>8',  '<cmd>BufferLineGoToBuffer 8<CR>', opts)
vim.keymap.set('n', '<leader>9',  '<cmd>BufferLineGoToBuffer 9<CR>', opts)
vim.keymap.set('n', '<leader>$',  '<cmd>BufferLineGoToBuffer -1<CR>', opts) -- last buffer

-- Pick buffer by letter overlay
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>',      opts)
vim.keymap.set('n', '<leader>bx', '<cmd>BufferLinePickClose<CR>', opts)


-- Vim Diff: push the diff to the right and move to the next diff
vim.keymap.set('n', 'Z',        'dp]c', opts)

-- Comment out a parameter.
--  useful for C++ code.
vim.cmd([[map C maviw:s_\v(/\*)=(%V\w*)(\*/)=_\=strpart("/*", strlen(submatch(1))).submatch(2).strpart("*/", strlen(submatch(3)))_<CR>`a]])

-- Open quickfix window (shows :make errors)
vim.keymap.set('n', '<leader>E', '<cmd>copen<CR>', { noremap = true, silent = true, desc = 'Open quickfix (errors)' })

-- Reload config (core files only - plugins require restart)
vim.keymap.set('n', '<leader>rr', function()
    dofile(vim.fn.stdpath('config') .. '/lua/core/options.lua')
    dofile(vim.fn.stdpath('config') .. '/lua/core/keymaps.lua')
    vim.notify('Config reloaded', vim.log.levels.INFO)
end, { desc = 'Reload config' })


