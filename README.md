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

### ~/.config/hypr

Linked per file, not as a whole directory — Omarchy owns the rest of this
directory and rewrites parts of it. `monitors.lua` in particular is edited with
`sed -i` every time the monitor-scaling binding runs, and `sed -i` replaces a
symlink with a regular file, which would silently detach the repo from the live
config. Display scale is per-machine anyway, so it stays out of the repo.

```sh
mkdir -p ~/.config/hypr
ln -sf "$PWD/.config/hypr/autostart.lua" ~/.config/hypr/autostart.lua
ln -sf "$PWD/.config/hypr/bindings.lua" ~/.config/hypr/bindings.lua
ln -sf "$PWD/.config/hypr/looknfeel.lua" ~/.config/hypr/looknfeel.lua
```

`bindings.lua` replaces Omarchy's ALT+TAB, which only cycles within the current
workspace, with two switchers that see every workspace: `window-switcher` below,
and hyprswitch's visual overlay. `autostart.lua` starts the hyprswitch daemon
the second one needs.

`looknfeel.lua` detaches the pointer from focus: the cursor no longer warps to a
window that gains focus, and hovering no longer takes focus. Both matter with the
scrolling layout, where focus decides which columns are on screen — clicking a
dock icon would otherwise teleport the cursor, and dragging the cursor across the
strip would scroll the target back out of view.

`omarchy refresh config hypr/<file>` copies Omarchy's default over one of these
and drops the symlink. Re-run the matching `ln -sf` after doing that.

### ~/.local/bin

```sh
mkdir -p ~/.local/bin
ln -sf "$PWD/.local/bin/window-switcher" ~/.local/bin/window-switcher
```

`window-switcher` is the ALT+TAB list from `bindings.lua`: every mapped window
across every workspace, most-recently-used first, filtered by typing. It needs
`fuzzel`, `jq`, and `gawk`. Icons come from a class-to-`Icon=` map built out of
the desktop files, because window classes are not icon names.

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
