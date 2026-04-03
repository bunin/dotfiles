# dotfiles

## Setup

Clone the repo and run the symlink commands below.

```sh
git clone git@github.com:bunin/dotfiles.git ~/projects/bunin/dotfiles
```

### ~/.config

```sh
ln -sf ~/projects/bunin/dotfiles/.config/alacritty ~/.config/alacritty
ln -sf ~/projects/bunin/dotfiles/.config/niri ~/.config/niri
ln -sf ~/projects/bunin/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/projects/bunin/dotfiles/.config/tmux ~/.config/tmux
ln -sf ~/projects/bunin/dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/projects/bunin/dotfiles/.config/xdg-desktop-portal ~/.config/xdg-desktop-portal
```

### ~/.claude

```sh
ln -sf ~/projects/bunin/dotfiles/.claude/settings.json ~/.claude/settings.json
ln -sf ~/projects/bunin/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/projects/bunin/dotfiles/.claude/statusline-command.sh ~/.claude/statusline-command.sh
```

### ~/.gemini

```sh
ln -sf ~/projects/bunin/dotfiles/.gemini/settings.json ~/.gemini/settings.json
```
