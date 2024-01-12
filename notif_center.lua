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

local notifbox=wibox.widget{
	margins=5,
	--widget=wibox.container.margin,
	layout=require("lib.util.overflow").vertical,
	scrollbar_enabled=false,
	spacing=3,
}

local create=function(icon,n)
	local box=wibox.widget{
		{
			{
				{
					{
						widget=wibox.widget.imagebox,
						image=icon,
						resize=true,
						forced_width=dpi(64),
						forced_height=dpi(64),
					},
					widget=wibox.container.margin,
					margins=5,
				},
				{
					{
						markup="<b>"..n.title.."</b>",
						widget=wibox.widget.textbox,
					},
					{
						text=n.text,
						widget=wibox.widget.textbox,
					},
					layout=wibox.layout.fixed.vertical,
				},
				layout=wibox.layout.align.horizontal,
			},
			widget=wibox.container.margin,
			margins=5,
		},
		widget=wibox.container.background,
		bg=beautiful.bg_minimize,
		shape=gears.shape.rounded_rect,
	}
	return box
end

local clear_notifs=wibox.widget{
	{
		text=" 󰎟 ",
		font="sans 12",
		widget=wibox.widget.textbox,
	},
	widget=wibox.container.background,
	bg=beautiful.bg_minimize,
}

local menu = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  x=dpi(10),
  y=dpi(205),
  shape=gears.shape.rounded_rect,
  widget={
	widget=wibox.container.margin,
	margins=5,
	{
		forced_width=200,
  		forced_height=510,
		{
			{
				{text="",widget=wibox.widget.textbox,},
				{text="Notifications",font="sans 14",widget=wibox.widget.textbox,},
				clear_notifs,
				layout=wibox.layout.align.horizontal,
			},
			widget=wibox.container.margin,
			margins=3,
		},
		{
			{text="",widget=wibox.widget.textbox,},
			notifbox,
			{text="",widget=wibox.widget.textbox,},
			layout=wibox.layout.align.horizontal,
			expand="center",
		},
		layout=wibox.layout.fixed.vertical,
	},
   },
})


naughty.connect_signal("added", function(n)
	local appicon = n.icon or n.app_icon
	if not appicon then
      appicon = gears.filesystem.get_configuration_dir() .. "icons/user.png"
    end
	notifbox:insert(1,create(appicon,n))
end)

clear_notifs:connect_signal("button::press",function()
	notifbox:reset(notifbox)
end)

awesome.connect_signal("notif::toggle",function()
	menu.visible=not menu.visible
end)
