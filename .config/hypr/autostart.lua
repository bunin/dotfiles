-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Daemon backing the ALT+TAB window switcher (see bindings.lua).
o.launch_on_start("hyprswitch init --show-title")

-- Hands back the fullscreen state that the screensaver takes off a window and
-- never returns (omacom/omarchy#3218).
o.launch_on_start("hypr-screensaver-fullscreen-restore")
