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

co=nil

local close=wibox.widget{
	{
		text="Close Window",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
local move=wibox.widget{
	{
		text="Move To Tag ",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
local resize=wibox.widget{
	{
		text="Resize Window",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}

local rcm=awful.popup{
	visible=false,
	ontop=true,
	x=0,
	y=0,
    border_width=1,
    border_color=beautiful.border_control,
    shape=gears.shape.rounded_rect,
	widget={
		forced_width=dpi(90),
		forced_height=dpi(50),
		layout=wibox.layout.align.vertical,
		expand="none",

		close,
		move,
		resize,
	},
}
resize:connect_signal("button::press",function()
	if(co~=nil)then
    	awful.mouse.client.resize(client.focus)
	end
end)

local w1=wibox.widget{
	{
		text="1",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
w1:connect_signal("mouse::enter",function()
	w1.bg=beautiful.bg_minimize
end)
w1:connect_signal("mouse::leave",function()
	w1.bg=beautiful.bg_normal
end)

local w2=wibox.widget{
	{
		text="2",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
w2:connect_signal("mouse::enter",function()
	w2.bg=beautiful.bg_minimize
end)
w2:connect_signal("mouse::leave",function()
	w2.bg=beautiful.bg_normal
end)
local w3=wibox.widget{
	{
		text="3",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
w3:connect_signal("mouse::enter",function()
	w3.bg=beautiful.bg_minimize
end)
w3:connect_signal("mouse::leave",function()
	w3.bg=beautiful.bg_normal
end)
local w4=wibox.widget{
	{
		text="4",
		align="center",
		widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_normal,
	widget=wibox.container.background,
}
w4:connect_signal("mouse::enter",function()
	w4.bg=beautiful.bg_minimize
end)
w4:connect_signal("mouse::leave",function()
	w4.bg=beautiful.bg_normal
end)
local work_pop=awful.popup{
	visible=false,
	ontop=true,
	x=dpi(90),
	y=0,
    border_width=1,
    border_color=beautiful.border_control,
    shape=gears.shape.rounded_rect,
	widget={
		forced_width=dpi(90),
		forced_height=dpi(50),
		layout=wibox.layout.align.vertical,
		expand="none",

		{w1,
		w2,layout=wibox.layout.align.vertical,},
		{widget=wibox.widget.textbox,text="",},
		{w3,
		w4,layout=wibox.layout.align.vertical,},
	},
}
w1:connect_signal("button::press",function()
    local tag = client.focus.screen.tags[1]
    client.focus:move_to_tag(tag)
	work_pop.visible=false
	rcm.visible=false
end)
w2:connect_signal("button::press",function()
    local tag = client.focus.screen.tags[2]
    client.focus:move_to_tag(tag)
	work_pop.visible=false
	rcm.visible=false
end)
w3:connect_signal("button::press",function()
    local tag = client.focus.screen.tags[3]
    client.focus:move_to_tag(tag)
	work_pop.visible=false
	rcm.visible=false
end)
w4:connect_signal("button::press",function()
    local tag = client.focus.screen.tags[4]
    client.focus:move_to_tag(tag)
	work_pop.visible=false
	rcm.visible=false
end)
awesome.connect_signal("win_rc::toggle",function(c)
	rcm.visible=not rcm.visible
	work_pop.visible=false
	work_pop.x=mouse.coords().x+dpi(91)
	work_pop.y=mouse.coords().y-dpi(10)
	rcm.x=mouse.coords().x
	rcm.y=mouse.coords().y-dpi(10)
	co=c
end)
move:connect_signal("mouse::enter",function()
	move.bg=beautiful.bg_minimize
	work_pop.visible=true
end)
close:connect_signal("button::press",function()
	client.focus:kill()
	work_pop.visible=false
	rcm.visible=not rcm.visible
end)
close:connect_signal("mouse::enter",function()
	close.bg=beautiful.bg_minimize
	work_pop.visible=false
end)
close:connect_signal("mouse::leave",function()
	close.bg=beautiful.bg_normal
end)
move:connect_signal("mouse::leave",function()
	move.bg=beautiful.bg_normal
end)
resize:connect_signal("mouse::enter",function()
	resize.bg=beautiful.bg_minimize
	work_pop.visible=false
end)
resize:connect_signal("mouse::leave",function()
	resize.bg=beautiful.bg_normal
end)
work_pop:connect_signal("mouse::leave",function()
	work_pop.visible=false
end)
