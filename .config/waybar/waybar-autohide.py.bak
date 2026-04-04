#!/usr/bin/python3
"""
Waybar autohide for niri (and other wlroots compositors).

Creates a thin invisible layer-shell surface on the screen edge.

When the bar is HIDDEN, the strip sits at the screen edge (e.g. x=0..6)
and acts as a hover-to-reveal trigger.

When the bar is VISIBLE, the strip repositions just past the bar's outer
edge (e.g. x=50..56 via a layer-shell margin) so waybar underneath
receives all pointer events (clicks, tooltips). The strip then acts as
an "exit detector" -- when the mouse crosses into it, a hide timer starts.
Moving back toward the bar cancels the timer.

Usage:
    waybar-autohide.py [--edge left|right|top|bottom] [--size 6] [--bar-size 50] [--delay 800]
"""

import argparse
import signal
import subprocess

import gi
gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gtk, Gdk, GLib, GtkLayerShell

# Map edge names to the GtkLayerShell margin edge used for repositioning
_MARGIN_EDGE = {
    "left": GtkLayerShell.Edge.LEFT,
    "right": GtkLayerShell.Edge.RIGHT,
    "top": GtkLayerShell.Edge.TOP,
    "bottom": GtkLayerShell.Edge.BOTTOM,
}


class WaybarAutohide:
    def __init__(self, edge="left", trigger_size=6, bar_size=50, hide_delay_ms=800):
        self.edge = edge
        self.trigger_size = trigger_size
        self.bar_size = bar_size
        self.hide_delay_ms = hide_delay_ms
        self.bar_visible = False
        self.hide_timer_id = None

        self.window = Gtk.Window()

        # Layer shell setup
        GtkLayerShell.init_for_window(self.window)
        GtkLayerShell.set_layer(self.window, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_namespace(self.window, "waybar-autohide")

        # Anchor to the chosen edge, spanning its full length
        if edge == "left":
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.LEFT, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.TOP, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.BOTTOM, True)
            self.window.set_size_request(trigger_size, -1)
        elif edge == "right":
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.RIGHT, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.TOP, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.BOTTOM, True)
            self.window.set_size_request(trigger_size, -1)
        elif edge == "top":
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.TOP, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.LEFT, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.RIGHT, True)
            self.window.set_size_request(-1, trigger_size)
        elif edge == "bottom":
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.BOTTOM, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.LEFT, True)
            GtkLayerShell.set_anchor(self.window, GtkLayerShell.Edge.RIGHT, True)
            self.window.set_size_request(-1, trigger_size)

        # Start with no margin (strip is at the screen edge)
        GtkLayerShell.set_margin(self.window, _MARGIN_EDGE[edge], 0)

        # Don't reserve space -- this is just a trigger zone
        GtkLayerShell.set_exclusive_zone(self.window, -1)

        # Make it transparent
        self.window.set_app_paintable(True)
        screen = self.window.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.window.set_visual(visual)

        # Draw fully transparent
        self.window.connect("draw", self._on_draw)

        # Mouse enter/leave events
        self.window.add_events(
            Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK
        )
        self.window.connect("enter-notify-event", self._on_enter)
        self.window.connect("leave-notify-event", self._on_leave)
        self.window.connect("destroy", Gtk.main_quit)

    def _reposition(self, margin):
        """Move the trigger strip by setting the layer-shell margin."""
        GtkLayerShell.set_margin(self.window, _MARGIN_EDGE[self.edge], margin)

    def _on_draw(self, widget, cr):
        cr.set_source_rgba(0, 0, 0, 0)
        cr.set_operator(0)  # CAIRO_OPERATOR_CLEAR
        cr.paint()
        return False

    def _on_enter(self, widget, event):
        if not self.bar_visible:
            # Mouse hit the edge strip -> show the bar
            if self.hide_timer_id is not None:
                GLib.source_remove(self.hide_timer_id)
                self.hide_timer_id = None
            self._toggle_waybar()
            self.bar_visible = True
            # Move strip past the bar so waybar gets all pointer events
            self._reposition(self.bar_size)
        else:
            # Mouse crossed into the exit strip -> start hide countdown
            if self.hide_timer_id is None:
                self.hide_timer_id = GLib.timeout_add(
                    self.hide_delay_ms, self._hide_bar
                )
        return False

    def _on_leave(self, widget, event):
        if self.bar_visible and self.hide_timer_id is not None:
            # Determine if mouse went back toward the bar or away from it.
            # If toward the bar, cancel the hide timer; otherwise let it fire.
            went_back = False
            if self.edge == "left":
                went_back = event.x < 0
            elif self.edge == "right":
                went_back = event.x >= self.trigger_size
            elif self.edge == "top":
                went_back = event.y < 0
            elif self.edge == "bottom":
                went_back = event.y >= self.trigger_size
            if went_back:
                GLib.source_remove(self.hide_timer_id)
                self.hide_timer_id = None
        return False

    def _hide_bar(self):
        if self.bar_visible:
            self._toggle_waybar()
            self.bar_visible = False
            # Move strip back to the screen edge
            self._reposition(0)
        self.hide_timer_id = None
        return False  # don't repeat

    def _toggle_waybar(self):
        subprocess.Popen(
            ["killall", "-SIGUSR1", "waybar"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    def run(self):
        self.window.show_all()
        Gtk.main()


def main():
    parser = argparse.ArgumentParser(description="Waybar autohide trigger zone")
    parser.add_argument(
        "--edge",
        choices=["left", "right", "top", "bottom"],
        default="left",
        help="Screen edge for the trigger zone (default: left)",
    )
    parser.add_argument(
        "--size",
        type=int,
        default=6,
        help="Width/height of the trigger strip in pixels (default: 6)",
    )
    parser.add_argument(
        "--bar-size",
        type=int,
        default=50,
        help="Width/height of waybar -- strip repositions past this (default: 50)",
    )
    parser.add_argument(
        "--delay",
        type=int,
        default=800,
        help="Delay in ms before hiding after mouse exits bar area (default: 800)",
    )
    args = parser.parse_args()

    # Handle SIGTERM/SIGINT gracefully
    signal.signal(signal.SIGTERM, lambda *_: Gtk.main_quit())
    signal.signal(signal.SIGINT, lambda *_: Gtk.main_quit())

    app = WaybarAutohide(
        edge=args.edge,
        trigger_size=args.size,
        bar_size=args.bar_size,
        hide_delay_ms=args.delay,
    )
    app.run()


if __name__ == "__main__":
    main()
