require('blink.cmp').setup({
  -- 'default' for mappings similar to built-in completion
  -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  keymap = { preset = 'default' },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },

  -- Default list of enabled providers defined by blink.cmp itself, usually allows for:
  -- 'lsp', 'path', 'snippets', 'buffer'
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'obsidian', 'obsidian_new', 'obsidian_tags' },
  },
})
