require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Documents/obsidian",
    },
  },
  legacy_commands = false,
  completion = {
    blink = true,
  },
})
