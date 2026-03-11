-- To insert Unicode characters like the ones below
-- 1) Enter Insert mode
-- 2) Enter Visual mode
-- 3) Type UNICDE character code (with u prefix)
-- Example "i<C-V>u00ca"     Ê (Should be a funny looking E)
-- Codes used below:
--   ¬       u00ac
--   ‣       u2023
--   ▸       u25b8
-- To get more information on what invisible characters can be mapped use :help listchars

-- Set what invisible characters looks like

vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ',
  trail = '␣',
}
--
--Note: Added the following to the colour scheme to make these characters stand out.
--      vim.cmd("highlight NonText guifg=#FFFFFF")
--      vim.cmd("highlight Whitespace guifg=#FFFFFF")

-- Keep a buffer of 15 lines top and bottom so the cursor does not
-- go all the way to the top of the window
vim.opt.scrolloff = 15

-- Turn on line numbers
-- Turning them both on will activate hybrid mode if available.
-- Or the last one selected if not
vim.wo.number = true                    -- Line Numbers
--vim.o.relativenumber = true

-- Line Wrapping
vim.o.wrap = false                      -- don't wrap lines of code
vim.o.linebreak = true

-- Enable line wrapping for markdown files only
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.opt_local.wrap = true
    end,
    desc = 'Wrap lines in markdown buffers',
})

-- With the below enabled any actions are also pulled onto the system clipboard.
-- This is pain for me as I still use the mouse and the system clipboard a lot
-- So I have disabled it.
--vim.o.clipboard = 'unnamedplus'         -- sync with system clipboard

-- Spelling options.
vim.opt.spell = true
vim.opt.spelllang = { "en_us", }

-- tabstop:          Width of tab character
-- expandtab:        When on uses space instead of tabs
-- softtabstop:      Fine tunes the amount of white space to be added
-- shiftwidth        Determines the amount of whitespace to add in normal mode
vim.o.tabstop       = 4
vim.o.softtabstop   = 4
vim.o.shiftwidth    = 4
vim.o.expandtab     = true

-- Auto Indenting
vim.opt.cindent     = true
vim.opt.smartindent = true
vim.opt.autoindent  = true

-- Searching
-- vim.o.ignorecase    = true

-- Line to long:
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "Red" })

-- Diagnostic Messages (LSP)
-- Are placed in the signcolumn. If this is not visable it will be inserted.
-- This insertion causes the text to jump right and then left when the error is removed.
-- By making sure the column is always there the text does not jump around.
vim.opt.signcolumn = 'yes'

-- Auto-reload files when changed externally (e.g., by Claude Code)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
    callback = function()
        if vim.fn.getcmdwintype() == '' then
            vim.cmd('checktime')
        end
    end,
    desc = 'Auto-reload files changed outside of Neovim',
})

-- Timer-based auto-reload (works even when in terminal/plugin windows)
local reload_timer = vim.uv.new_timer()
reload_timer:start(1000, 1000, vim.schedule_wrap(function()
    if vim.fn.getcmdwintype() == '' then
        vim.cmd('checktime')
    end
end))

--
vim.opt.makeprg = "NEOVIM=TRUE make"

-- Auto-reload config files when saved
-- Note: Plugin files won't fully reload (lazy.nvim manages those)
local config_path = vim.fn.stdpath('config')
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = config_path .. '/lua/core/*.lua',
    callback = function(args)
        dofile(args.file)
        vim.notify('Reloaded: ' .. vim.fn.fnamemodify(args.file, ':t'), vim.log.levels.INFO)
    end,
    desc = 'Auto-reload core config files on save',
})

-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
    desc = 'Restore cursor position on file open',
})

-- Session options - what to save/restore
vim.opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos'

-- Auto-save session on exit (per directory)
vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        local session_dir = vim.fn.stdpath('state') .. '/sessions'
        vim.fn.mkdir(session_dir, 'p')
        local cwd = vim.fn.getcwd():gsub('/', '_')
        local session_file = session_dir .. '/' .. cwd .. '.vim'
        vim.cmd.mksession({ session_file, bang = true })
    end,
    desc = 'Auto-save session on exit',
})

-- Auto-load session on startup (if one exists for this directory)
vim.api.nvim_create_autocmd('VimEnter', {
    nested = true,
    callback = function()
        if vim.fn.argc() == 0 then
            local session_dir = vim.fn.stdpath('state') .. '/sessions'
            local cwd = vim.fn.getcwd():gsub('/', '_')
            local session_file = session_dir .. '/' .. cwd .. '.vim'
            if vim.fn.filereadable(session_file) == 1 then
                vim.cmd.source(session_file)
            end
        end
    end,
    desc = 'Auto-load session on startup',
})

