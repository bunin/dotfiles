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
ln -sf "$PWD/.config/waybar" ~/.config/waybar
ln -sf "$PWD/.config/xdg-desktop-portal" ~/.config/xdg-desktop-portal
```

### ~/.config/tmux

Linked per file, not as a whole directory — tpm installs plugins into
`~/.config/tmux/plugins/`, which have no business in the repo.

```sh
mkdir -p ~/.config/tmux
ln -sf "$PWD/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
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
ln -sf "$PWD/.config/fish/functions/vi.fish" ~/.config/fish/functions/vi.fish
```

`brew.fish` runs Homebrew as the dedicated `homebrew` user. `-H` points `HOME` at
that user, so Homebrew never reaches for `~/Library` (mode 700, unreadable to it)
and no `HOMEBREW_CACHE`/`HOMEBREW_CASK_OPTS` overrides are needed.

`vim.fish` and `vi.fish` make `vim`/`vi` run Neovim; `config.fish` sets
`EDITOR`/`VISUAL`/`SUDO_EDITOR` to it so git, `kubectl edit`, and friends agree.
`command vim` still reaches the system Vim — note macOS Vim lacks
`+xterm_clipboard`, so `clipboard=unnamedplus` is silently a no-op there.

### Vale

Linked per file, not as a whole directory — Vale writes downloaded packages
(`styles/`) and other generated state next to `.vale.ini` that should stay out
of the repo.

Vale looks for the config in `~/Library/Application Support/vale` on macOS and
in `~/.config/vale` on Linux.

```sh
# macOS
mkdir -p ~/Library/Application\ Support/vale
ln -sf "$PWD/.config/vale/.vale.ini" ~/Library/Application\ Support/vale/.vale.ini

# Linux
mkdir -p ~/.config/vale
ln -sf "$PWD/.config/vale/.vale.ini" ~/.config/vale/.vale.ini
```

Then download the styles the config references:

```sh
vale sync
```

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
