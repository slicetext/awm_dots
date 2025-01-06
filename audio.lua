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
local user=require("settings")
local rubato=require "lib.rubato"

local ud=wibox.widget{
	text="󰝝",
	font="sans 80",
	align="center",
	widget=wibox.widget.textbox,
}

pop=awful.popup{
  ontop = true,
  visible = true,
  border_width=4,
  border_color=beautiful.border_control,
  placement=awful.placement.centered,
  shape=gears.shape.rounded_rect,
  widget={
	forced_width=dpi(100),
	forced_height=dpi(100),
	widget=wibox.container.margins,
	margins=0,
	layout=wibox.layout.align.vertical,
	expand="none",
	ud,
	--{widget=wibox.widget.textbox,text=" "},
	--volumeText,
  },
}
local delay=5
time=gears.timer{
	timeout=1,
	autostart=true,
	callback=function()
		if(pop.visible==true)then
			delay=delay-1
		end
		if(delay<=0)then
			pop.visible=false
			delay=5
		end
	end,
}
awesome.connect_signal("volume::up",function()
	awful.spawn("pactl set-sink-volume 0 +5%")
	ud.text="󰝝"
	pop.visible=true
    pop.screen=awful.screen.focused()
end)
awesome.connect_signal("volume::down",function()
	awful.spawn("pactl set-sink-volume 0 -5%")
	ud.text="󰝞"
	pop.visible=true
    pop.screen=awful.screen.focused()
end)
awesome.connect_signal("volume::mute",function()
	awful.spawn("pactl set-sink-volume 0 0%")
	ud.text="󰝟"
	pop.visible=true
    pop.screen=awful.screen.focused()
end)
awesome.connect_signal("bright::up",function()
	awful.spawn("brightnessctl s +10%")
	ud.text="󰃠"
	pop.visible=true
    pop.screen=awful.screen.focused()
end)
awesome.connect_signal("bright::down",function()
	awful.spawn("brightnessctl s 10%-")
	ud.text="󰃞"
	pop.visible=true
    pop.screen=awful.screen.focused()
end)
