# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Waybar configuration for a horizontal top-edge bar running on the niri Wayland compositor. The bar auto-hides via a custom GTK layer-shell trigger zone.

## Key Files

- **config** — Waybar JSON config. Horizontal top bar (`position: top`, 36px tall). Modules use icon-only format with tooltips for details. Bar starts hidden (`start_hidden: true`, `exclusive: false`).
- **style.css** — GTK CSS using Catppuccin Mocha color palette. All module selectors use `#id` format; grouped modules (clock, power) have nested selectors like `#clock-group #clock`.
- **waybar-autohide.py** — Python/GTK3 layer-shell daemon that creates an invisible trigger strip at the screen edge. Sends `SIGUSR1` to waybar to toggle visibility. Args: `--edge`, `--size`, `--bar-size`, `--delay`.
- **mediaplayer.py** — Playerctl-based MPRIS media player module (outputs JSON for waybar custom module).
- **clockify.sh** — Custom module showing Clockify time tracker status via `clockify-cli`.

## Architecture Notes

- The bar uses **niri-specific modules** (`niri/workspaces`, `niri/language`) and should use as many as possible - this is a niri-specific setup.
- Autohide mechanism: `waybar-autohide.py` creates an overlay-layer transparent GTK window. When hidden, the strip sits at y=0; when visible, it shifts past the bar height so waybar receives pointer events. Hide has a 300ms delay to prevent flicker.
- Module groups (`group/power`, `group/clock`) stack modules vertically within the bar.

## Applying Changes

systemctl --user restart waybar.service
