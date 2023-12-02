-- Standard awesome library
local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
require("awful.autofocus")
local rubato=require "lib.rubato"
local user=require("settings")

local visible=true

local pause = wibox.widget({
  text = "󰐎",
  widget = wibox.widget.textbox,
})

local  nexts = wibox.widget({
  text = "󰒭 ",
  widget = wibox.widget.textbox,
})

local  prevs = wibox.widget({
  text = " 󰒮",
  widget = wibox.widget.textbox,
})
local song = wibox.widget({
	text = "Song",
	widget=wibox.widget.textbox,
})
local artist = wibox.widget({
	text = "Artist",
	widget=wibox.widget.textbox,
})
local cover = wibox.widget({
	widget=wibox.widget.imagebox,
})
local player = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
border_color=beautiful.border_control,
  --placement=awful.placement.bottom_right,
  y=dpi(650),
  x=dpi(1200),
  shape=gears.shape.rounded_rect,
  widget = {
    widget = wibox.container.background,
    forced_width = 150,
    forced_height = 75,
	{
		widget=wibox.container.margin,
		{
		layout=wibox.layout.align.vertical,
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				song,
				artist,
				layout = wibox.layout.align.vertical,
			},
		},
    	{
    		layout = wibox.layout.align.horizontal,
			expand="none",
			prevs,
    		pause,
			nexts,
    	},
	},
	},
},
})

local upA=rubato.timed{
	duration=1/3,
	into=1/6,
	easing=rubato.quadratic,
	subscribed=function(pos) player.x=pos end,
}
pause:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl play-pause \
  ")
end)

prevs:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl previous \
  ")
end)
nexts:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl next \
  ")
end)
awesome.connect_signal("music::toggle",function()
	if(user.animations==true)then
	visible=not visible
	if(visible==true)then
		player.visible=true
		upA:abort()
		--menu.x=dpi(1210)
		upA.target=dpi(1400)
	else
		player.visible=true
		upA:abort()
		--menu.x=dpi(1190)
		upA.target=dpi(1200)
	end
	else
	player.x=dpi(1200)
	player.visible=not player.visible
end
end)
local function titles()	
	awful.spawn.easy_async_with_shell("playerctl metadata title",function(out)
	if(out=="") then
		song.text=" Nothing is Playing"
	else
		song.text=" "..out
	end
	end)
	awful.spawn.easy_async_with_shell("playerctl metadata artist",function(out)
	if(out=="") then
		artist.text=" Unknown Artist"
	else
		artist.text=" "..out
	end
	end)
	awful.spawn.easy_async_with_shell("playerctl status",function(out)
	if(out=="Playing\n") then
		pause.text="󰏤"
	else
		pause.text="󰐊"
	end
	end)
end

local timer=gears.timer{
	timeout=1,
	autostart=true,
	callback=function()
		titles()
	end,
}
