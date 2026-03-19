
-- https://github.com/akinsho/bufferline.nvim
return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {
        'moll/vim-bbye',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('bufferline').setup({
            highlights = {
                buffer_selected = {
                    fg = '#ff0000',
                    bold = true,
                },
            },
            options = {
                mode = "buffers",                       -- set to "tabs" to only show tabpages instead
                -- style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
                themable = true,                        -- true | false, -- allows highlight groups to be overriden i.e. sets highlights as default
                numbers = "ordinal",                    -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                close_command = "bdelete! %d",          -- can be a string | function, | false see "Mouse actions"
                right_mouse_command = "bdelete! %d",    -- can be a string | function | false, see "Mouse actions"
                left_mouse_command = "buffer %d",       -- can be a string | function, | false see "Mouse actions"
                middle_mouse_command = nil,             -- can be a string | function, | false see "Mouse actions"
                indicator = {
                    -- icon = '▎',                         -- this should be omitted if indicator style is not 'icon'
                    style = 'icon',                     -- 'icon' | 'underline' | 'none',
                },
                buffer_close_icon = '󰅖',
                modified_icon = '● ',
                close_icon = ' ',
                left_trunc_marker = ' ',
                right_trunc_marker = ' ',
                max_name_length = 18,
                max_prefix_length = 15,             -- prefix used when a buffer is de-duplicated
                truncate_names = true,              -- whether or not tab names should be truncated
                tab_size = 18,
                diagnostics = false,                -- false | "nvim_lsp" | "coc",
                diagnostics_update_in_insert = false, -- only applies to coc
                diagnostics_update_on_event = true, -- use nvim's diagnostic handler
                -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    return "("..count..")"
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",     -- "File Explorer" | function ,
                        text_align = "left",        -- "left" | "center" | "right"
                        separator = true
                    }
                },
                color_icons = true,                 -- true | false, -- whether or not to add the filetype icon highlights
                show_buffer_icons = true,           -- true | false, -- disable filetype icons for buffers
                show_buffer_close_icons = true,     -- true | false,
                show_close_icon = true,             -- true | false,
                show_tab_indicators = true,         -- true | false,
                show_duplicate_prefix = true,       -- true | false, -- whether to show duplicate buffer prefix
                duplicates_across_groups = true,    -- whether to consider duplicate paths in different groups as duplicates
                persist_buffer_sort = true,         -- whether or not custom sorted buffers should persist
                move_wraps_at_ends = false,         -- whether or not the move command "wraps" at the first or last position
                -- can also be a table containing 2 custom separators
                -- [focused and unfocused]. eg: { '|', '|' }
                separator_style = "slant",          -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
                enforce_regular_tabs = false,       -- false | true,
                always_show_bufferline = true,      -- true | false,
                auto_toggle_bufferline = true,      -- true | false,
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = {'close'}
                },
                sort_by = "insert_after_current",
                --[[
                    'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
                    -- add custom logic
                    local modified_a = vim.fn.getftime(buffer_a.path)
                    local modified_b = vim.fn.getftime(buffer_b.path)
                    return modified_a > modified_b
                end,
                --]]
                pick = {
                  alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
                },
            }
        })
    end,
}

