require 'core.options'
require 'core.keymaps'

-- Install NerdFonts
--      brew install --cask font-hack-nerd-font
-- Install ripgrep for telescope
--      brew install ripgrep
-- Modify Terminal configurations:
--      1: Use NerdFonts
--              iterm2/Settings.../profiles/text/font = Hack Nerd Fond Mono
--      2: Context aware cursor color.
--              iterm2/Settings.../profiles/colors/Context Aware Cursor Color


-- Package Manager
-- Lazy:
--    See :help lazy.nvim.txt
--    or https://github.com/folke/lazy.nvim for more info
--
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    require('plugins.neotree'),
    require('plugins.colourtheme'),
    require('plugins.bufferline'),
    require('plugins.lualine'),
    require('plugins.treesitter'),
    require('plugins.telescope'),

})


