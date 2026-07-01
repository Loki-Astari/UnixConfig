-- Terminal window/tab title management (for iTerm2 and other terminals).
--
-- Sets two distinct titles via OSC escape sequences:
--   * Tab title    (OSC 1): just the filename — stays compact when the
--                           iTerm2 tab bar is visible (more than one tab).
--   * Window title (OSC 2): full "project — file" — the title bar has room
--                           for it, and it follows the focused tab.
--
-- The project name is the basename of the git toplevel (the folder you
-- think of as the GitHub project), falling back to the cwd when not in a
-- repo. We take full control of the title, so neovim's own 'title' option
-- is turned off to avoid it overwriting ours.

vim.opt.title = false

-- Basename of the git root, or of the cwd if we're not inside a repo.
local function project_name()
  local root = vim.fs.root(0, '.git')
  return vim.fn.fnamemodify(root or vim.fn.getcwd(), ':t')
end

-- OSC sequences don't move the cursor or touch screen content, so writing
-- them directly to the terminal is safe alongside neovim's renderer.
-- Terminated with BEL (\007), which iTerm2 accepts.
local function set_titles()
  local file = vim.fn.expand('%:t')
  local project = project_name()
  local tab = file ~= '' and file or project
  local window = file ~= '' and (project .. ' — ' .. file) or project
  io.write('\027]1;' .. tab .. '\007')    -- tab title
  io.write('\027]2;' .. window .. '\007') -- window title
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'DirChanged' }, {
  callback = set_titles,
  desc = 'Set iTerm2 tab/window title from git project and filename',
})

-- Reset the title to the project/cwd name on exit so the shell prompt
-- isn't left showing a stale filename.
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    local project = project_name()
    io.write('\027]1;' .. project .. '\007')
    io.write('\027]2;' .. project .. '\007')
  end,
  desc = 'Reset terminal title on exit',
})
