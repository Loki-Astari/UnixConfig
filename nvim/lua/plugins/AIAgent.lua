return {
    'Loki-Astari/AIAgent',
    config = function()
      require("aiagent").setup({
        width = 0.4,  -- 40% of screen width (or use integers for columns)
        command = "claude",
        -- show_header = false,
      })
    end,
    whichkey = function(wk)

       wk.add({
           mode = { "n", "v" },
           {'<leader>a', group = "Agent"},
           {'<leader>ao', ':AgentOpen<cr>', desc = "Open agent (default)"},
           {'<leader>ac', ':AgentOpen Cursor<cr>', desc = "Open Cursor agent"},
           {'<leader>ax', ':AgentClose<cr>', desc = "Close current agent" },
           {'<leader>aT', ':AgentToggle<cr>', desc = "Toggle current agent" },
           {'<leader>as', ':AgentSendSelection<cr>', desc = "Send selection to agent" },
           {'<leader>ad', ':AgentSendDiagnostics<cr>', desc = "Send Diagnostic to agent" },
           {'<leader>a ', ':AgentSessions<cr>', desc = "Open the Agent Session Selector"},
           {'<leader>ar', ':AgentSessions!<cr>', desc = "Replays the Agent Session Selector"},
           {'<leader>ah', ':AgentDiff<cr>', desc = "Open the Agent Diff Viewer"},
           {'<leader>al', ':AgentList!<cr>', desc = "List agents in all Neovim instances"},
           {'<leader>ag', ':AgentTree<cr>', desc = "Session history tree"},
           {'<leader>af', ':AgentFind<cr>', desc = "Find an old Session"},
           {'<leader>at', ':AgentTree<cr>', desc = "Agent Session Tree"},
        })
        wk.add({
           {'<leader>sc', ':set ic!<CR>',   desc = 'Toggle case sensative search'}
        })
   end,
}


