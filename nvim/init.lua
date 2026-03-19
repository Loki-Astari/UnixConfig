-- Enable bytecode cache for faster module loading
vim.loader.enable()

require 'core.options'
require 'core.keymaps'

vim.opt.runtimepath:prepend("/Users/myork/Repo/Claude")

-- Install NerdFonts
--      brew install --cask font-hack-nerd-font
-- Install ripgrep for telescope
--      brew install ripgrep
-- Modify Terminal configurations:
--      1: Use NerdFonts
--              IMPORTANT: Without this, file-type icons in bufferline tabs will
--              appear as squares with question marks instead of the correct icons.
--              iTerm2 → Settings → Profiles → Text → Font
--              Set to: Hack Nerd Font Mono
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
    require('plugins.lsp'),
    require('plugins.autocomplete'),
    require('plugins.gitsigns'),
    require('plugins.whichkey'),
    require('plugins.commands'),
    require('plugins.clojure'),
    -- AI Tools
    require('plugins.AIAgent'),
})


