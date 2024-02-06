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

local term_width=100
local term_height=100
local menu = awful.popup({
	ontop = true,
	visible = false,
	border_width=4,
	border_color=beautiful.border_control,
	y=0,
	x=(user.width/2)-term_width/2,
	y=(user.height/2)-term_height/2,
	widget={
		forced_width=term_width,
		forced_height=term_height,
	}
})

run=function(command)
	awful.spawn.easy_async_with_shell(command,function(out)
		return out
	end)
end
