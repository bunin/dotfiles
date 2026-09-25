# Names herdr tabs "<position>:<command>" after the last command run in them,
# the way tmux's "#I:#W" with automatic-rename did. herdr has no such option of
# its own, so every command started from a pane renames the pane's tab.
#
# A name that isn't a bare number or "<number>:<word>" was set by hand, and like
# a tmux rename it turns the automatic naming off for that tab. The position is
# read when the command starts, so after closing or moving a tab the numbers of
# the others catch up with their next command.
status is-interactive; or return
set -q HERDR_TAB_ID; or return
command -q herdr; or return
command -q jq; or return

function __herdr_tab_name_preexec --on-event fish_preexec
    set -l words (string split -n ' ' -- $argv[1])
    # Skip the wrappers so `sudo pacman -Syu` names the tab after pacman.
    while set -q words[2]; and begin
            contains -- $words[1] sudo doas env time command builtin exec nice nohup
            or string match -qr '^-|^[A-Za-z_][A-Za-z0-9_]*=' -- $words[1]
        end
        set -e words[1]
    end
    set -q words[1]; or return
    set -l name (path basename -- $words[1])

    set -l tabs (command herdr tab list --workspace $HERDR_WORKSPACE_ID 2>/dev/null |
        jq -r '.result.tabs[] | "\(.tab_id)\t\(.label)"')
    or return
    for i in (seq (count $tabs))
        set -l tab (string split \t -- $tabs[$i])
        test "$tab[1]" = "$HERDR_TAB_ID"; or continue
        string match -qr '^[0-9]+(:\S+)?$' -- $tab[2]; or return
        set -l label "$i:$name"
        test "$tab[2]" = "$label"; and return
        command herdr tab rename $HERDR_TAB_ID $label >/dev/null 2>&1
        return
    end
end
