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

local terminal=wibox.widget{
	{
		text="Open Terminal",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
}
local run=wibox.widget{
	{
		text="Run App",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
}
local tools=wibox.widget{
	{
		text="Tools",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
}

local rcm=awful.popup{
	visible=false,
	ontop=true,
	x=mouse.coords().x,
	y=mouse.coords().y,
    border_width=4,
    border_color=beautiful.border_control,
    shape=gears.shape.rounded_rect,
	widget={
		forced_width=dpi(90),
		forced_height=dpi(50),
		layout=wibox.layout.align.vertical,
		expand="none",
		terminal,
		run,
		tools,
	},
}


terminal:connect_signal("mouse::enter",function()
	terminal.bg=beautiful.bg_minimize
end)
terminal:connect_signal("mouse::leave",function()
	terminal.bg=beautiful.bg_normal
end)
terminal:connect_signal("button::press",function()
	awful.spawn.with_shell(user.terminal)
	awesome.emit_signal("rclick::toggle")
end)
run:connect_signal("mouse::enter",function()
	run.bg=beautiful.bg_minimize
end)
run:connect_signal("mouse::leave",function()
	run.bg=beautiful.bg_normal
end)
run:connect_signal("button::press",function()
	awesome.emit_signal("launch::toggle")
	awesome.emit_signal("rclick::toggle")
end)
tools:connect_signal("mouse::enter",function()
	tools.bg=beautiful.bg_minimize
end)
tools:connect_signal("mouse::leave",function()
	tools.bg=beautiful.bg_normal
end)
tools:connect_signal("button::press",function()
	awesome.emit_signal("tools::toggle")
	awesome.emit_signal("rclick::toggle")
end)
awesome.connect_signal("rclick::toggle",function()
	rcm.visible=not rcm.visible
	rcm.x=mouse.coords().x
	rcm.y=mouse.coords().y
end)
