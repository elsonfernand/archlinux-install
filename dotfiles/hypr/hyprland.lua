-- Converted Hyprland Lua config
-- Source: previous hyprland.conf / Hyprlang config
-- Target path: ~/.config/hypr/hyprland.lua
-- Hyprland >= 0.55 uses Lua for configuration.

------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal     = "kitty"
local fileManager   = "thunar"
local menu          = "wofi --show drun"
local browser       = "brave"
local textEditor    = "code-oss"
local videoEditor   = "kdenlive"
local audioEditor   = "ardour8"
local vectorEditor  = "inkscape"
local imageEditor   = "gimp"
local mainMod       = "SUPER"
local screenshotsDir = (os.getenv("HOME") or "~") .. "/Pictures/Screenshots"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("~/.local/bin/start-portal")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("sleep 1 && waybar")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("Telegram -startintray")
  hl.exec_cmd("numlockx on")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("mako")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- XDG variables
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Backend variables
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 3,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(c8c8c8ff)", "rgba(5c5c5cff)" }, angle = 45 },
      inactive_border = "rgba(808080aa)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 7,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 0.8,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },

    blur = {
      enabled = true,
      size = 2,
      passes = 1,
      vibrancy = 0.15,
      ignore_opacity = true,
      -- new_optimizations was present in older configs. If your Hyprland build still supports it,
      -- you can uncomment the line below. Leaving it commented avoids unknown-option errors.
      -- new_optimizations = true,
    },
  },

  animations = {
    enabled = true,
  },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},   {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",     enabled = true, speed = 8,   bezier = "default" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3.8, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.4, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "border",     enabled = true, speed = 4.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2.4, bezier = "quick" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",   enabled = true, speed = 3.8, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",  enabled = true, speed = 1.4, bezier = "linear",       style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "default",      style = "slidefade 20%" })

-----------------
---- LAYOUTS ----
-----------------

hl.config({
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "br",
    kb_variant = "",
    kb_model = "abnt2",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    numlock_by_default = true,

    touchpad = {
      natural_scroll = false,
    },
  },
})

-- The old `gestures { workspace_swipe = false }` line was commented out.
-- If you want to enable a gesture later, define it explicitly with hl.gesture().

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local function bind_exec(keys, cmd, flags)
  hl.bind(keys, hl.dsp.exec_cmd(cmd), flags)
end

-- Software
bind_exec(mainMod .. " + A", audioEditor)
bind_exec(mainMod .. " + B", browser)
bind_exec(mainMod .. " + C", "galculator")
bind_exec(mainMod .. " + D", menu)
bind_exec(mainMod .. " + E", textEditor)
bind_exec(mainMod .. " + F", fileManager)
bind_exec(mainMod .. " + G", imageEditor)
bind_exec(mainMod .. " + H", "helium-browser")
bind_exec(mainMod .. " + I", vectorEditor)
bind_exec(mainMod .. " + K", videoEditor)
bind_exec(mainMod .. " + S", "shotcut")
bind_exec(mainMod .. " + X", "hyprlock")

-- Printscreen
bind_exec(mainMod .. " + SHIFT + Print", "hyprshot -m region -o " .. screenshotsDir)
bind_exec(mainMod .. " + Print",         "hyprshot -m output -o " .. screenshotsDir)
bind_exec("SHIFT + Print",               "hyprshot -m region -o " .. screenshotsDir)
bind_exec("Print",                       "hyprshot -m output -o " .. screenshotsDir)

-- General utilities
bind_exec(mainMod .. " + Escape", "pkill waybar || waybar")
bind_exec(mainMod .. " + Return", terminal)
bind_exec(mainMod .. " + SHIFT + D", "kitty --hold hyprctl clients")

-- Behavior
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
bind_exec(mainMod .. " + SHIFT + R", "hyprctl reload")
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces and move active window to workspace
for i = 1, 10 do
  local key = i % 10 -- workspace 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace / scratchpad, still disabled because SUPER+S already opens Shotcut.
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize active window
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 100,  y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -100, y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,    y = -100, relative = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,    y = 100,  relative = true }))

-- Multimedia keys
bind_exec("XF86AudioRaiseVolume", "~/.local/bin/volume-osd up",   { locked = true, repeating = true })
bind_exec("XF86AudioLowerVolume", "~/.local/bin/volume-osd down", { locked = true, repeating = true })
bind_exec("XF86AudioMute",        "~/.local/bin/volume-osd mute", { locked = true, repeating = true })
bind_exec("XF86AudioMicMute",     "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true, repeating = true })

-- Requires playerctl
bind_exec("XF86AudioNext",  "playerctl next",       { locked = true })
bind_exec("XF86AudioPause", "playerctl play-pause", { locked = true })
bind_exec("XF86AudioPlay",  "playerctl play-pause", { locked = true })
bind_exec("XF86AudioPrev",  "playerctl previous",   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Duplicated maximize/XWayland rules from the old file were consolidated here.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

------------------
---- FLOATING ----
------------------

hl.window_rule({
  name = "PulseAudio Volume Control",
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  center = true,
})

hl.window_rule({
  name = "Galculator",
  match = { class = "galculator" },
  float = true,
  center = true,
  size = { "monitor_w * 0.3", "monitor_h * 0.15" },
})

hl.window_rule({
  name = "Print Config",
  match = { class = "system-config-printer" },
  float = true,
  center = true,
})

hl.window_rule({
  name = "Rename dialog",
  match = { title = "^(Rename.*)" },
  float = true,
  center = true,
  size = { "monitor_w * 0.3", "monitor_h * 0.15" },
})

--------------------------------
---- PROGRAMS IN WORKSPACES ----
--------------------------------

hl.window_rule({ name = "Brave Browser",  match = { class = "brave-browser" },        workspace = "1" })
hl.window_rule({ name = "Code OSS",       match = { class = "code-oss" },             workspace = "2" })
hl.window_rule({ name = "Kdenlive",       match = { class = "org.kde.kdenlive" },     workspace = "3" })
hl.window_rule({ name = "Shotcut",        match = { class = "org.shotcut.Shotcut" },  workspace = "3" })
hl.window_rule({ name = "GIMP",           match = { class = "gimp" },                 workspace = "4" })
hl.window_rule({ name = "Inkscape",       match = { class = "org.inkscape.Inkscape" }, workspace = "5" })
hl.window_rule({ name = "Telegram",       match = { class = "org.telegram.desktop" }, workspace = "6" })
hl.window_rule({ name = "Darktable",      match = { class = "darktable" },            workspace = "7" })
hl.window_rule({ name = "Ardour",         match = { class = "Ardour-8.12.0" },        workspace = "8", tile = true })
hl.window_rule({ name = "Helium Browser", match = { class = "^helium$" },             workspace = "9" })

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = { 20, "monitor_h-120" },
  float = true,
})

------------
---- BLUR ----
------------

hl.window_rule({
  name = "blur-disable-empty-xwayland",
  match = {
    xwayland = true,
    class = "^$",
    title = "^$",
  },
  no_blur = true,
})

---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" }, blur = true })
hl.layer_rule({ name = "blur-wofi",   match = { namespace = "^wofi$" },   blur = true })
