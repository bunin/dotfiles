-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
hl.config({
  cursor = {
    -- Leave the pointer where it is when focus moves to another window,
    -- e.g. when clicking an icon in the dock. no_warps covers focus changes
    -- on the current workspace; warp_on_change_workspace covers the jump
    -- that comes with switching workspaces (Omarchy defaults it to 1).
    no_warps = true,
    warp_on_change_workspace = 0,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    -- Detach pointer focus from keyboard focus (Omarchy defaults to 1).
    -- With the scrolling layout, focus drives which columns are on screen,
    -- so hover-to-focus scrolls the strip out from under you whenever the
    -- cursor crosses a column on its way somewhere else. Clicking still
    -- moves keyboard focus; hover and scroll still reach the window below.
    follow_mouse = 2,
  },
})
