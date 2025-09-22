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

vim.o.clipboard = 'unnamedplus'         -- sync with system clipboard

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
vim.o.ignorecase    = true

-- Line to long:
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "Red" })

-- Diagnostic Messages (LSP)
-- Are placed in the signcolumn. If this is not visable it will be inserted.
-- This insertion causes the text to jump right and then left when the error is removed.
-- By making sure the column is always there the text does not jump around.
vim.opt.signcolumn = 'yes'

--

