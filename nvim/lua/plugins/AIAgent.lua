return {
    'Loki-Astari/AIAgent',
    config = function()
      require("aiagent").setup({
        width = 0.4,  -- 40% of screen width (or use integers for columns)
        command = "claude",
      })
    end,
}


