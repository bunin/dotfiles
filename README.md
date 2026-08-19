# dotfiles

## Setup

Clone the repo, navigate to its directory, and run the symlink commands below.

```sh
git clone git@github.com:bunin/dotfiles.git
cd dotfiles
```

### ~/.config

```sh
ln -sf "$PWD/.config/alacritty" ~/.config/alacritty
ln -sf "$PWD/.config/mako" ~/.config/mako
ln -sf "$PWD/.config/niri" ~/.config/niri
ln -sf "$PWD/.config/nvim" ~/.config/nvim
ln -sf "$PWD/.config/tmux" ~/.config/tmux
ln -sf "$PWD/.config/waybar" ~/.config/waybar
ln -sf "$PWD/.config/xdg-desktop-portal" ~/.config/xdg-desktop-portal
```

### ~/.config/fish

Linked per file, not as a whole directory — fish writes generated state next to
these (`fish_variables`, `completions/`, `conf.d/omf.fish`) that should stay out
of the repo.

```sh
mkdir -p ~/.config/fish/functions
ln -sf "$PWD/.config/fish/config.fish" ~/.config/fish/config.fish
ln -sf "$PWD/.config/fish/functions/brew.fish" ~/.config/fish/functions/brew.fish
ln -sf "$PWD/.config/fish/functions/vim.fish" ~/.config/fish/functions/vim.fish
```

`brew.fish` runs Homebrew as the dedicated `homebrew` user; `HOMEBREW_CASK_OPTS`
in `config.fish` keeps cask fonts out of `~/Library`, which that user cannot
read.

`vim.fish` makes `vim` run Neovim; `config.fish` sets `EDITOR`/`VISUAL` to it so
git, `kubectl edit`, and friends agree. `command vim` still reaches the system
Vim — note macOS Vim lacks `+xterm_clipboard`, so `clipboard=unnamedplus` is
silently a no-op there.

### ~/.claude

```sh
mkdir -p ~/.claude
ln -sf "$PWD/.claude/settings.json" ~/.claude/settings.json
ln -sf "$PWD/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$PWD/.claude/keybindings.json" ~/.claude/keybindings.json
ln -sf "$PWD/.claude/statusline-command.sh" ~/.claude/statusline-command.sh
```

### ~/.gemini

```sh
mkdir -p ~/.gemini
ln -sf "$PWD/.gemini/settings.json" ~/.gemini/settings.json
ln -sf "$PWD/.gemini/GEMINI.md" ~/.gemini/GEMINI.md
```
