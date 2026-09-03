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

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + J", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + K", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + J", "Move window to next workspace", hl.dsp.window.move({ workspace = "e+1" }))
o.bind("SUPER + SHIFT + K", "Move window to previous workspace", hl.dsp.window.move({ workspace = "e-1" }))

-- The three Omarchy defaults that HJKL displaced, rehomed on SUPER+ALT.
o.bind("SUPER + ALT + H", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
