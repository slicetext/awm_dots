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

local sign_out=wibox.widget{
	text="",
	font="sans 20",
	widget=wibox.widget.textbox,
}
local power=wibox.widget{
	text="󰐥",
	font="sans 15",
	widget=wibox.widget.textbox,
}

local menu=awful.popup{
	visible=false,
	ontop=true,
    border_width=4,
    border_color=beautiful.border_control,
	shape=gears.shape.rounded_rect,
	placement=awful.placement.centered,
	widget={
		widget=wibox.container.margin,
		margins=5,
		{
			forced_width=50,
			forced_height=40,
			layout=wibox.layout.align.horizontal,
			power,
			{text=" ",widget=wibox.widget.textbox,},
			sign_out,
			expand="none",
		},
	},
}

sign_out:connect_signal("button::press",function()
	awesome.quit()
end)
power:connect_signal("button::press",function()
	awful.spawn("shutdown now")
end)
awesome.connect_signal("power::toggle",function()
	menu.visible=not menu.visible
end)
