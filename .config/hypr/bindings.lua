-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Window switching across all workspaces, replacing Omarchy's ALT+TAB, which
-- only cycles within the current workspace.
--
-- ALT+TAB       type-to-filter list (fuzzel); most-recent window is preselected
-- ALT+SHIFT+TAB hyprswitch's visual overlay with live previews; its daemon is
--               started in autostart.lua
local hyprswitch = "hyprswitch gui --mod-key ALT_L --key tab --close mod-key-release --reverse-key=mod=shift"

hl.unbind("ALT + TAB")
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + TAB", "Window switcher (search)", "window-switcher")
o.bind("ALT + SHIFT + TAB", "Window switcher (visual)", hyprswitch)

-- SUPER+` steps through the focused app's own windows, the way CMD+` does on
-- macOS. hyprswitch's simple mode switches on the spot instead of opening the
-- overlay the two bindings above use: one press is one switch, and there is
-- nothing left on screen to dismiss.
--
-- SUPER rather than ALT, because Hyprland forwards the modifier to the focused
-- window even when it swallows the key the binding fires on. GTK reads that as
-- a bare ALT tap and pops the menu bar open behind the switch. SUPER is not a
-- menu accelerator anywhere.
o.bind("SUPER + grave", "Next window of the same app", "hyprswitch simple --filter-same-class")
o.bind("SUPER + SHIFT + grave", "Previous window of the same app", "hyprswitch simple --filter-same-class --reverse")

-- Vim-style navigation, alongside the arrow keys, which keep their defaults.
--
-- The scrolling layout makes every workspace one horizontal strip of columns,
-- so the two axes split cleanly: H/L walk the strip, J/K walk the workspaces.
-- Focusing a window up or down has no meaning in a strip, so it stays on the
-- arrows only.
hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + SHIFT + H")
hl.unbind("SUPER + SHIFT + J")
hl.unbind("SUPER + SHIFT + K")
hl.unbind("SUPER + SHIFT + L")

-- Omarchy's own workspace bindings, SUPER+TAB and SUPER+scroll included, pass
-- Hyprland's "e+1" selector, which means "relative *open* workspace": it walks
-- only the workspaces that already exist and wraps around them. On a fresh
-- session with a single workspace there is nowhere to walk to, so the key does
-- nothing and workspace 2 is never created. Stepping by ID creates the empty
-- workspace on the way in.
--
-- The step is capped at workspace_count so J/K stay inside the range SUPER+1..5
-- can jump to directly. The cap lifts to the current ID when that is already
-- higher, so pressing J on workspace 8 holds there instead of jumping back.
local workspace_count = 5

local function workspace_step(delta, dispatch)
  return function()
    local active = hl.get_active_workspace()
    local current = active and active.id or 1
    local ceiling = math.max(workspace_count, current)
    local target = math.min(ceiling, math.max(1, current + delta))

    return hl.dispatch(dispatch(target))
  end
end

local function focus_workspace(target)
  return hl.dsp.focus({ workspace = target })
end

local function move_window_to_workspace(target)
  return hl.dsp.window.move({ workspace = target })
end

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + J", "Next workspace", workspace_step(1, focus_workspace))
o.bind("SUPER + K", "Previous workspace", workspace_step(-1, focus_workspace))

-- Omarchy's swap bindings, the arrow keys included, dispatch swapwindow, which
-- belongs to the tiling layouts. Scrolling ignores it, and it refuses a
-- fullscreen or maximized window outright ("Can't swap fullscreen window"), so
-- on a scrolling workspace it never fires. swapcol is the layout's own message
-- and swaps whole columns; the swap wraps, so the leftmost column sent left
-- reappears at the end of the strip.
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.layout("swapcol l"))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.layout("swapcol r"))
o.bind("SUPER + SHIFT + LEFT", "Swap window to the left", hl.dsp.layout("swapcol l"))
o.bind("SUPER + SHIFT + RIGHT", "Swap window to the right", hl.dsp.layout("swapcol r"))
o.bind("SUPER + SHIFT + J", "Move window to next workspace", workspace_step(1, move_window_to_workspace))
o.bind("SUPER + SHIFT + K", "Move window to previous workspace", workspace_step(-1, move_window_to_workspace))

-- The three Omarchy defaults that HJKL displaced, rehomed on SUPER+ALT.
o.bind("SUPER + ALT + H", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Close active window (alongside default SUPER+W)
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

