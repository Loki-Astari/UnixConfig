-- https://github.com/3rd/diagram.nvim
-- https://github.com/3rd/image.nvim
--
-- Renders ```mermaid code blocks inline in markdown buffers.
--
-- External requirements:
--      brew install imagemagick                    -- image.nvim (magick_cli processor)
--      npm install -g @mermaid-js/mermaid-cli      -- provides `mmdc`
--
-- Terminal:
--      iTerm2 does not speak the kitty graphics protocol, so image.nvim uses
--      the sixel backend. (iTerm2 >= 3.5 supports sixel out of the box.)
--      If you switch to kitty/ghostty/wezterm, change backend to "kitty".

return {
    '3rd/diagram.nvim',
    ft = { 'markdown' },
    dependencies = {
        {
            '3rd/image.nvim',
            build = false,      -- don't build the magick luarock; we use magick_cli
            opts = {
                backend = 'sixel',
                processor = 'magick_cli',
                integrations = {
                    markdown = {
                        enabled = true,
                        -- Only diagrams; don't try to render ![](...) image links.
                        only_render_image_at_cursor = false,
                        filetypes = { 'markdown' },
                        download_remote_images = false,
                    },
                    neorg = { enabled = false },
                    html  = { enabled = false },
                    css   = { enabled = false },
                },
                max_width_window_percentage  = 80,
                max_height_window_percentage = 50,
                window_overlap_clear_enabled = true,
                window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'blink-cmp-menu', 'snacks_notif', 'scrollview', 'scrollview_sign' },
                editor_only_render_when_focused = true,
                tmux_show_only_in_active_window = true,
            },
        },
    },
    opts = function()
        return {
            integrations = {
                require('diagram.integrations.markdown'),
            },
            events = {
                render_buffer = { 'InsertLeave', 'BufWinEnter', 'TextChanged' },
                clear_buffer  = { 'BufLeave' },
            },
            renderer_options = {
                mermaid = {
                    -- Solid background: sixel drops semi-transparent pixels,
                    -- which made the thin connector lines vanish.
                    -- Quoted because diagram.nvim runs mmdc through the shell
                    -- and a bare '#' would start a comment.
                    background = "'#303446'",   -- catppuccin frappe base
                    scale = 2,
                    -- Theme, colours, line thickness: mermaid/config.json
                    -- After editing it, clear the cache:
                    --     rm -rf ~/.cache/nvim/diagram-cache/mermaid/*
                    cli_args = { '-c', vim.fn.stdpath('config') .. '/mermaid/config.json' },
                },
            },
        }
    end,
    keys = {
        {
            '<leader>md',
            function() require('diagram').show_diagram_hover() end,
            mode = 'n',
            ft = { 'markdown' },
            desc = 'Mermaid: show diagram in new tab',
        },
    },
}
