-- https://github.com/catppuccin/nvim

-- Which flavour to use for each background. Changing these changes both what
-- loads at startup and what <leader>tt toggles between.
local flavours = {
    light = "latte",
    dark  = "frappe",
}

-- Cursor and whitespace colours have to contrast with the background, so they
-- cannot be hard coded. A colorscheme change also wipes any highlight set here,
-- so this is re-applied from a ColorScheme autocmd rather than called once.
local function apply_background_overrides()
    local dark = vim.o.background == "dark"

    -- The cursor was black on iTerm2 on the mac.
    -- Need to make the cursor contrast with the background.
    local cursor = dark and "white" or "black"
    vim.api.nvim_set_hl(0, "nCursor", {fg = dark and "black" or "white", bg = cursor})
    vim.api.nvim_set_hl(0, "iCursor", {fg = cursor, bg = cursor})
    vim.o.guicursor = "n-v-c:block-nCursor,i:ver100-iCursor,r-cr:hor20,o:hor50"

    -- Make tabs and trailing spaces stand out.
    local whitespace = dark and "#FFFFFF" or "#000000"
    vim.api.nvim_set_hl(0, "NonText",    {fg = whitespace})
    vim.api.nvim_set_hl(0, "Whitespace", {fg = whitespace})
end

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "auto", -- latte, frappe, macchiato, mocha, auto (follows vim.o.background)
            background = flavours, -- :h background
            transparent_background = false, -- disables setting the background color.
            float = {
                transparent = false, -- enable transparent floating windows
                solid = false, -- use solid styling for floating windows, see |winborder|
            },
            show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
            term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false, -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            no_underline = false, -- Force no underline
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { "italic" }, -- Change the style of comments
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },
            color_overrides = {},
            custom_highlights = {},
            default_integrations = true,
            auto_integrations = false,
            integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
                notify = false,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        -- Registered before the colorscheme loads, so the initial load applies it too.
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("CatppuccinBackgroundOverrides", { clear = true }),
            callback = apply_background_overrides,
            desc = 'Keep cursor and whitespace colours readable on both backgrounds',
        })

        -- Turn on the colour scheme (flavour picked from vim.o.background).
        vim.cmd("colorscheme catppuccin")
    end,
    whichkey = function(wk)
        wk.add({
            -- Theme (<leader>t "Toggle" group is declared in gitsigns.lua)
            {'<leader>tt', function()
                local target = vim.o.background == "dark" and "light" or "dark"
                -- Loading the flavour by name also sets vim.o.background to match.
                vim.cmd("colorscheme catppuccin-" .. flavours[target])
                vim.notify("Theme: " .. target .. " (" .. flavours[target] .. ")", vim.log.levels.INFO)
            end, desc = 'Toggle Light/Dark Theme'},
        })
    end,
}
