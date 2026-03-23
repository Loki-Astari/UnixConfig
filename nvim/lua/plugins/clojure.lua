
-- https://github.com/Olical/conjure

return {
    'Olical/conjure',
    -- NOTE: 'lua' was removed to prevent conjure from loading on init.lua (saves ~10ms startup).
    -- Add back any languages you actively use with conjure.
    ft = { 'clojure', 'fennel', 'scheme', 'lisp', 'racket' },
    init = function()
      -- Disable the floating HUD so it doesn't overlap the AIAgent window
      vim.g["conjure#log#hud#enabled"] = false
    end,
    config = function()
      -- Keymap: open Conjure log below AIAgent in the right column
      vim.keymap.set('n', '<leader>cr', function()
        -- Find the AIAgent window (rightmost vertical split)
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local rightmost_win = nil
        local max_col = -1
        for _, win in ipairs(wins) do
          local pos = vim.api.nvim_win_get_position(win)
          if pos[2] > max_col then
            max_col = pos[2]
            rightmost_win = win
          end
        end

        if not rightmost_win then
          vim.notify('No right-side window found', vim.log.levels.WARN)
          return
        end

        local ok, log = pcall(require, 'conjure.log')
        if not ok then
          vim.notify('Conjure not loaded yet — open a Clojure file first', vim.log.levels.WARN)
          return
        end

        -- Move into the AIAgent window, then split within that column
        vim.api.nvim_set_current_win(rightmost_win)
        log.split()
      end, { desc = 'Open Conjure REPL below AIAgent' })
    end,
}
