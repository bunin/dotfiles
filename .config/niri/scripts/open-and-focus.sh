#!/usr/bin/env bash

# Open the link
xdg-open "$1"

# Give the browser a moment to receive the link and open/map the window
sleep 0.1

# Attempt to focus the Firefox window
# We use the app_id found earlier: org.mozilla.firefox
WINDOW_ID=$(niri msg --json windows | jq -r '.[] | select(.app_id == "org.mozilla.firefox") | .id' | head -1)

if [ -n "$WINDOW_ID" ]; then
    niri msg action focus-window --id "$WINDOW_ID"
fi
