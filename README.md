# dotfiles

## Setup

Clone the repo, navigate to its directory, and run the symlink commands below.

```sh
git clone git@github.com:bunin/dotfiles.git
cd dotfiles
```

### ~/.config

```sh
ln -sf "$PWD/.config/mako" ~/.config/mako
ln -sf "$PWD/.config/niri" ~/.config/niri
ln -sf "$PWD/.config/nvim" ~/.config/nvim
ln -sf "$PWD/.config/waybar" ~/.config/waybar
ln -sf "$PWD/.config/xdg-desktop-portal" ~/.config/xdg-desktop-portal
```

### ~/.config/alacritty

Linked per file, not as a whole directory — `omarchy refresh config
alacritty/alacritty.toml` copies Omarchy's default over this one and replaces
the symlink with a regular file, and a directory link would hide that by letting
the refresh write straight into the repo.

```sh
mkdir -p ~/.config/alacritty
ln -sf "$PWD/.config/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
```

`alacritty.toml` is Omarchy's default with a `[hints]` block added, so the theme
`general.import`, the font, and the CSI-u Return bindings stay as Omarchy ships
them. Because it is the top-level config rather than an overlay, an `omarchy
update` that changes the packaged default does not reach it — diff against
`/usr/share/omarchy/config/alacritty/alacritty.toml` after updating.

The hint puts a letter from `alphabet` on every URL on screen and opens the one
you type, `CTRL+SHIFT+U`. Alacritty handles the binding before the foreground
app sees it, so it works with herdr in front — but not before fcitx5, which is
why `~/.config/fcitx5/conf/unicode.conf` above has to give the combo up; `Alt+click` in the same block does
not, because herdr's `mouse_capture` claims the mouse. Opening goes through
`omarchy-launch-browser`, which also focuses the browser window — `xdg-open`
alone leaves that half undone.

### ~/.config/fcitx5

Linked per file — fcitx5 keeps `profile` and a generated `conf/cached_layouts`
next to these, and Omarchy ships its own `conf/clipboard.conf` and
`conf/xcb.conf` into the same directory.

```sh
mkdir -p ~/.config/fcitx5/conf
ln -sf "$PWD/.config/fcitx5/conf/unicode.conf" ~/.config/fcitx5/conf/unicode.conf
```

`unicode.conf` clears one hotkey: the fcitx5 unicode addon takes
`CTRL+SHIFT+U` for direct hex entry, and fcitx5 holds the Wayland
input-method grab, so it got the key before Alacritty and the URL hint below
never fired. Its other trigger, `CTRL+ALT+SHIFT+U`, stays. Apply it without a
restart with `gdbus call --session --dest org.fcitx.Fcitx5 --object-path
/controller --method org.fcitx.Fcitx.Controller1.ReloadAddonConfig unicode`.

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

`looknfeel.lua` also takes Omarchy's window transparency off the focused window
and leaves it on the others. The wallpaper no longer shows through whatever you
work in, while an unfocused window still reads as unfocused. `SUPER+BACKSPACE`
toggles transparency for one window.

`omarchy refresh config hypr/<file>` copies Omarchy's default over one of these
and drops the symlink. Re-run the matching `ln -sf` after doing that.

### ~/.local/bin

```sh
mkdir -p ~/.local/bin
ln -sf "$PWD/.local/bin/window-switcher" ~/.local/bin/window-switcher
ln -sf "$PWD/.local/bin/herdr-clockify-status" ~/.local/bin/herdr-clockify-status
ln -sf "$PWD/.local/bin/herdr-kube-status" ~/.local/bin/herdr-kube-status
ln -sf "$PWD/.local/bin/herdr-url-pick" ~/.local/bin/herdr-url-pick
```

`window-switcher` is the ALT+TAB list from `bindings.lua`: every mapped window
across every workspace, most-recently-used first, filtered by typing. It needs
`fuzzel`, `jq`, and `gawk`. Icons come from a class-to-`Icon=` map built out of
the desktop files, because window classes are not icon names.

`herdr-url-pick` is `PREFIX+ALT+U` from `config.toml` below: the URLs in the
focused herdr pane, newest first, filtered by typing in `fzf`, opened the same
way the Alacritty hint opens one. It exists because the hint reads the visible
grid, where a pane border cuts a long URL in two and anything scrolled off is
gone; this asks the herdr server for the pane's scrollback unwrapped instead.

`herdr-clockify-status` ports the old `tmux-clockify` status segment to Herdr's
tab row: while a timer is running it shows `project / description [H:MM:SS]`.
Herdr redraws the elapsed time every second, but the script refreshes Clockify
at most once a minute and shows nothing when no timer runs. Herdr runs status
commands asynchronously, so the occasional API refresh does not block its UI.

`--json` prints the same timer as the Waybar-style object the Omarchy bar's
`command` module expects, so the OS bar carries it beside the clock without a
second Clockify poller — both readers share the one cache under
`~/.cache/herdr-clockify`. The bar slot is narrow, so there the label is just
the glyph and `H:MM`, with `project / description` in the tooltip.
`~/.config/omarchy/shell.json` is not in this repo (the shell rewrites it
whenever a bar gesture moves a widget), so the entry goes in by hand, ahead of
`omarchy.clock` in `bar.layout.right`:

```json
{
  "id": "clockify",
  "type": "command",
  "exec": "~/.local/bin/herdr-clockify-status --json",
  "interval": 60,
  "onClick": "omarchy-launch-or-focus-webapp clockify https://app.clockify.me/tracker"
}
```

The bar drops the seconds and wakes once a minute because it runs `command`
modules through `bash -lc`: the login shell costs more than the script it is
there to run, and the module's timer keeps firing even while no timer is being
tracked. Once a minute that is free, and it lands on the same cadence as the
Clockify refresh anyway. Herdr keeps `H:MM:SS` — it redraws its own tab row and
calls the script without a login shell.

The module drops out of the bar on its own when no timer runs, because an empty
`text` gives the widget no width. Nothing sets `class` to `active`: that paints
the label in the theme's urgent color, and a running timer is the ordinary
state. `omarchy-launch-or-focus-webapp` matches `clockify` against window
classes and titles, so a click focuses an open tracker instead of stacking up
another window.

`herdr-kube-status` adds the current Kubernetes `context / namespace` beside the
Clockify timer. It reads the local kubeconfig every five seconds without
contacting the cluster, uses `default` when a context has no explicit namespace,
and hides itself when no current context is configured.

### ~/.config/tmux

Linked per file, not as a whole directory — tpm installs plugins into
`~/.config/tmux/plugins/`, which have no business in the repo.

```sh
mkdir -p ~/.config/tmux
ln -sf "$PWD/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
```

### ~/.config/herdr

Linked per file, not as a whole directory — herdr keeps its sockets, logs, and
session state (`herdr.sock`, `herdr-server.log`, `session.json`) next to the
config, and none of that belongs in the repo.

```sh
mkdir -p ~/.config/herdr
ln -sf "$PWD/.config/herdr/config.toml" ~/.config/herdr/config.toml
```

`config.toml` translates the tmux config above into herdr's vocabulary — session
to workspace, window to tab — so the prefix and the splits stay where
`tmux.conf` put them. `default_shell` names fish outright because herdr
otherwise takes `$SHELL` from whatever started its server, which is the shell of
that terminal rather than the login shell.

The tab row is also Herdr's status bar. Its right side carries zoom state, the
cached `herdr-clockify-status` command, Kubernetes context and namespace, and
the server hostname, in that order, with centered dots separating the segments.

`mouse_capture` keeps herdr's own mouse UI — click a pane to focus it, click a
tab, drag a border — at the price of the terminal's middle-click paste, since
herdr reports mouse events to itself instead. `SHIFT` is the way out: Alacritty
handles a shift-modified mouse event rather than reporting it, so `SHIFT+drag`
selects into the primary buffer and `SHIFT+MIDDLE` pastes from it. Plain
selection inside herdr goes to the clipboard only — it travels as OSC 52 `52;c`,
which has no primary-buffer half.

`[[keys.command]]` binds `PREFIX+ALT+U` to `herdr-url-pick` in a popup pane,
since herdr's own actions stop at `copy_mode` and `edit_scrollback` and none of
them reaches a URL.

`herdr server reload-config`, or `CTRL+SPACE q`, applies changes to the running
server. Panes that are already open keep the shell they started with.

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
ln -sf "$PWD/.config/fish/functions/k.fish" ~/.config/fish/functions/k.fish
ln -sf "$PWD/.config/fish/functions/kc.fish" ~/.config/fish/functions/kc.fish
ln -sf "$PWD/.config/fish/functions/kn.fish" ~/.config/fish/functions/kn.fish
```

`brew.fish` runs Homebrew as the dedicated `homebrew` user. `-H` points `HOME` at
that user, so Homebrew never reaches for `~/Library` (mode 700, unreadable to it)
and no `HOMEBREW_CACHE`/`HOMEBREW_CASK_OPTS` overrides are needed.

`vim.fish` and `vi.fish` make `vim`/`vi` run Neovim; `config.fish` sets
`EDITOR`/`VISUAL`/`SUDO_EDITOR` to it so git, `kubectl edit`, and friends agree.
`command vim` still reaches the system Vim — note macOS Vim lacks
`+xterm_clipboard`, so `clipboard=unnamedplus` is silently a no-op there.

`k.fish`, `kc.fish`, and `kn.fish` are the everyday Kubernetes shorthands —
`kubectl`, `kubectx`, `kubens` — installed by the mise config below. They are
functions rather than aliases so `--wraps` applies: `k` inherits kubectl's own
completions, so `k get po<TAB>` completes pod names.

kubectl generates its own fish completions rather than carrying them in the
release, so they go into `completions/` and stay out of the repo. Run this once
per machine:

```sh
kubectl completion fish > ~/.config/fish/completions/kubectl.fish
```

The kubectx and kubens tarballs don't carry fish completions, so `kc` and `kn`
complete nothing. Both list their choices when run bare.

### ~/.config/bash

fish is the login shell; bash is what an ssh session, a rescue console, or a
terminal started without fish drops you into, and it also runs every `bash -c`
the session spawns — including the `!` shell escape in Claude Code.
`kubernetes.bash` gives all of those the same `k`/`kc`/`kn` shorthands the fish
functions above provide.

Non-interactive bash ignores aliases, so these have to be functions. Reaching
those shells at all takes `BASH_ENV`: bash skips its startup files for
`bash -c`, yet it still reads whatever `BASH_ENV` names. `config.fish` exports it,
so any bash descended from a fish shell picks the functions up; `~/.bashrc`
sources the same `env.bash` for interactive shells, which ignore `BASH_ENV`.

That makes `env.bash` run ahead of every bash script this session starts, so
keep it silent, quick, and free of side effects — definitions only, no output,
no PATH edits, no `set -e`. It ends in `true` because a trailing failed test
would otherwise become the script's starting exit status. Twenty `bash -c true`
runs took the same 27ms with it as without.

Omarchy seeds `~/.bashrc` and that file sources Omarchy's own rc, an unguarded
line that fails on a machine without Omarchy, so `~/.bashrc` stays out of the
repo and only these two files go in:

```sh
mkdir -p ~/.config/bash
ln -sf "$PWD/.config/bash/env.bash" ~/.config/bash/env.bash
ln -sf "$PWD/.config/bash/kubernetes.bash" ~/.config/bash/kubernetes.bash
```

Then add the source line to `~/.bashrc`, under "Add your own exports, aliases,
and functions here":

```sh
[[ -r ~/.config/bash/env.bash ]] && source ~/.config/bash/env.bash
```

A bash started outside a fish session — from a graphical launcher, say — never
sees `BASH_ENV`, so the functions reach it only if it happens to be interactive.

Completions work as they do under fish: generated per machine, kept out of the
repo. bash-completion loads them on demand from
`~/.local/share/bash-completion/completions`, so the second file below exists to
point `k` at kubectl's completions:

```sh
kubectl completion bash > ~/.local/share/bash-completion/completions/kubectl
cat > ~/.local/share/bash-completion/completions/k <<'EOF'
. "$HOME/.local/share/bash-completion/completions/kubectl"
complete -o default -F __start_kubectl k
EOF
```

### ~/.config/mise

Linked per file, not as a whole directory — mise keeps machine-local settings
(`settings.toml`) alongside `config.toml`, and installed toolchains under
`~/.local/share/mise`, none of which belong in the repo.

```sh
mkdir -p ~/.config/mise
ln -sf "$PWD/.config/mise/config.toml" ~/.config/mise/config.toml
```

`config.toml` is the global tool list `config.fish` activates. `mise use -g
<tool>` writes through the symlink rather than replacing it, so installing a
tool edits the repo file directly and shows up as a diff here. Install
everything already listed with:

```sh
mise install
```

`node` names an exact version on purpose. Everything else tracks `latest`.

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
mkdir -p ~/.gemini/antigravity-cli
ln -sf "$PWD/.gemini/antigravity-cli/settings.json" ~/.gemini/antigravity-cli/settings.json
```

`omarchy-agent-usage-antigravity` automatically preserves `"notifications": false`
and maintains this symlink whenever it queries `agy --print '/quota'`, working
around Go's `omitempty` serialization bug.

