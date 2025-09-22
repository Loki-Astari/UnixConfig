return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(opts)
        local wk = require('which-key')
        wk.setup(opts or wk.opts or {})

        local plugins = require('lazy').plugins()
        for index, plugin in pairs(plugins) do
            if (plugin.whichkey ~= nil and type(plugin.whichkey) == "function") then
                plugin.whichkey(wk)
            end
        end
    end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
