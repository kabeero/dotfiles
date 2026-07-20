---@module 'hl'

local fileManager = "dolphin"
local terminal = "kitty"
local menu = "rofi -show combi -theme " .. os.getenv("HOME") .. "/.config/rofi/launchers/type-6/style-1.rasi"

local mod = "SUPER"
local moveMod = "SUPER + SHIFT"

local function smart_toggle_split()
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end

	-- Query the active layout on the current workspace
	local layout = ws.tiled_layout

	if layout == "dwindle" then
		-- Dwindle layout: standard togglesplit
		hl.dispatch(hl.dsp.layout("togglesplit"))
	elseif layout == "scrolling" then
		-- Scrolling layout: dynamically toggle split state of the active window
		local w = hl.get_active_window()
		if w and w.layout and w.layout.name == "scrolling" then
			-- Count windows currently sharing the active column
			local num_windows = #w.layout.column.windows
			if num_windows > 1 then
				-- Vertically split (stacked in column). Split horizontally.
				hl.exec_cmd("hyprctl dispatch scroller:expelwindow")
			else
				-- Horizontally split (lone window in column). Split vertically.
				hl.exec_cmd("hyprctl dispatch scroller:admitwindow")
			end
		end
	end
end

hl.env("HYPRCURSOR_SIZE", 64)
hl.env("XCURSOR_SIZE", 64)

hl.config({
	animations = {},
})

hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + code:24", hl.dsp.window.close()) -- '
hl.bind("CTRL + SHIFT + X", hl.dsp.exit())
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(fileManager))

hl.bind(mod .. " + code:36", hl.dsp.exec_cmd(terminal)) -- enter
hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + M", hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind("Print", hl.dsp.exec_cmd("grimblast copysave area"))
hl.bind(mod .. " + o", hl.dsp.exec_cmd("grimblast copysave area"))
hl.bind(mod .. " + SHIFT + o", hl.dsp.exec_cmd("swappy -f $(grimblast copysave area)"))

hl.bind(mod .. " + space", hl.dsp.window.float())
hl.bind(moveMod .. " + P", hl.dsp.window.pin())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + E", smart_toggle_split)
hl.bind(mod .. " + W", hl.dsp.group.toggle())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen()) -- gaps
hl.bind(moveMod .. " + F", hl.dsp.window.fullscreen()) -- no gaps

hl.bind(mod .. " + q", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + code:52", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mod .. " + j", hl.dsp.layout("move -col"))
hl.bind(mod .. " + left", hl.dsp.layout("move -col"))
hl.bind(mod .. " + comma", hl.dsp.layout("move -col"))
hl.bind(mod .. " + k", hl.dsp.layout("move +col"))
hl.bind(mod .. " + right", hl.dsp.layout("move +col"))
hl.bind(mod .. " + period", hl.dsp.layout("move +col"))

hl.bind(moveMod .. " + comma", hl.dsp.layout("swapcol l"))
hl.bind(moveMod .. " + period", hl.dsp.layout("swapcol r"))

hl.bind(moveMod .. " + j", hl.dsp.window.move({ direction = "left" }))
hl.bind(moveMod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(moveMod .. " + k", hl.dsp.window.move({ direction = "right" }))
hl.bind(moveMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(moveMod .. " + q", hl.dsp.window.move({ direction = "up" }))
hl.bind(moveMod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(moveMod .. " + code:52", hl.dsp.window.move({ direction = "down" }))
hl.bind(moveMod .. " + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mod .. " + code:10", hl.dsp.focus({ workspace = 1 }))
hl.bind(mod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = 1 }, { follow = false }))
hl.bind(mod .. " + code:11", hl.dsp.focus({ workspace = 2 }))
hl.bind(mod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = 2 }, { follow = false }))
hl.bind(mod .. " + code:12", hl.dsp.focus({ workspace = 3 }))
hl.bind(mod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = 3 }, { follow = false }))
hl.bind(mod .. " + code:13", hl.dsp.focus({ workspace = 4 }))
hl.bind(mod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = 4 }, { follow = false }))
hl.bind(mod .. " + code:14", hl.dsp.focus({ workspace = 5 }))
hl.bind(mod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = 5 }, { follow = false }))
hl.bind(mod .. " + code:15", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = 6 }, { follow = false }))
hl.bind(mod .. " + code:16", hl.dsp.focus({ workspace = 7 }))
hl.bind(mod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = 7 }, { follow = false }))
hl.bind(mod .. " + code:17", hl.dsp.focus({ workspace = 8 }))
hl.bind(mod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = 8 }, { follow = false }))
hl.bind(mod .. " + code:18", hl.dsp.focus({ workspace = 9 }))
hl.bind(mod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = 9 }, { follow = false }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.config({
	cursor = {
		hide_on_key_press = true,
		no_hardware_cursors = true,
	},
	decoration = {
		blur = {
			enabled = true,
			passes = 1,
			size = 8,
			vibrancy = 0.1696,
		},
		shadow = {
			color = "rgba(0a092099)",
			enabled = true,
			range = 4,
			render_power = 3,
		},
		active_opacity = 1.000000,
		inactive_opacity = 0.800000,
		rounding = 10,
		rounding_power = 2,
	},
	dwindle = {
		preserve_split = true,
	},
	general = {
		border_size = 2,
		gaps_in = 5,
		gaps_out = 20,
		layout = "scrolling",
		resize_on_border = false,
		col = {
			active_border = "rgb(258fc4)",
			inactive_border = "rgb(333773)",
		},
	},
	group = {
		groupbar = {
			col = {
				active = "rgb(258fc4)",
				inactive = "rgb(333773)",
			},
			enabled = true,
			gaps_out = 8,
			height = 32,
			indicator_gap = -6,
			indicator_height = 6,
			keep_upper_gap = true,
			render_titles = false,
			rounding = 2,
			text_color = "rgb(606bac)",
		},
		col = {
			border_active = "rgb(258fc4)",
			border_inactive = "rgb(333773)",
			border_locked_active = "rgb(a2faf0)",
		},
	},
	input = {
		touchpad = {
			natural_scroll = true,
		},
		accel_profile = "flat",
		follow_mouse = false,
		kb_layout = "us",
		kb_variant = "dvorak",
		natural_scroll = true,
		repeat_delay = 180,
		repeat_rate = 100,
		sensitivity = 0.3,
	},
	misc = {
		background_color = "rgb(0a0920)",
		disable_hyprland_logo = true,
	},
})

-- 2-finger swipe + SUPER to resize active window
hl.gesture({
	fingers = 2,
	direction = "swipe",
	mods = "SUPER",
	action = "resize",
})

-- 2-finger pinch + SUPER to float/tile active window
hl.gesture({
	fingers = 2,
	direction = "pinch",
	mods = "SUPER",
	action = "float",
})

-- 3-finger vertical swipe to fullscreen
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = "fullscreen",
})

-- 3-finger left swipe to move columns
hl.gesture({
	fingers = 3,
	direction = "left",
	action = function()
		hl.dispatch(hl.dsp.layout("move +col"))
	end,
})

-- 3-finger right swipe to move columns
hl.gesture({
	fingers = 3,
	direction = "right",
	action = function()
		hl.dispatch(hl.dsp.layout("move -col"))
	end,
})

-- 4-finger horizontal swipe to switch workspaces
hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
})

-- -- 4-finger vertical swipe to toggle hyprexpo
-- hl.gesture({
--     fingers   = 4,
--     direction = "vertical",
--     action    = function()
--         hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo toggle"))
--     end,
-- })

-- workspace switching
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- hl.plugin("hyprbars", function()
--     bar_height = 20,
--     on_double_click = "hyprctl dispatch fullscreen 1",
-- end)

-- hl.plugin("hyprscrolling", function()
--     column_width = 0.90,
--     fullscreen_on_one_column = true,
-- end)

hl.window_rule({
	name = "match_class_kitty",
	match = {
		class = "^(kitty)$",
	},
	opacity = "0.90 0.80 1.0",
})

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl plugin load /nix/store/yjhaz78n7hcax04wjcmpcjyv3x91966p-hyprexpo-0.1/lib/libhyprexpo.so")
	hl.exec_cmd(
		"hyprctl plugin load /nix/store/scm1hanl4vs8dz9zh7lngmakfxks8hla-hyprscrolling-0.1/lib/libhyprscrolling.so"
	)
	hl.exec_cmd("hyprctl plugin load /nix/store/vqfzfhmhcgbbwqll23csgxyhbqbnmpzf-hy3-hl0.53.0/lib/libhy3.so")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waybar")
end)
