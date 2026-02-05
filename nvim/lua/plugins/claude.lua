return {
    'Loki-Astari/claude',
    config = function()
      require("claude").setup({
        width = 0.4,  -- 40% of screen width (or use integers for columns)
        command = "claude",
      })
    end,
}


