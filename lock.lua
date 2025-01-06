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
local gfs = require("gears.filesystem")
local conf_path = gfs.get_configuration_dir()
awful.screen.connect_for_each_screen(function(s)
local window = wibox{
  ontop = true,
  visible = false,
  screen=s,
}
awful.placement.maximize(window)

local pr=wibox.widget{
	image=user.user_icon or conf_path.."icons/user.png",
	widget=wibox.widget.imagebox,
	resize=true,
	forced_width=80,
	forced_height=80,
	halign="center",
	visible=true,
}

local pt=wibox.widget{
	{
		text="Enter Password...",
		widget=wibox.widget.textbox,
		id="box",
		align="center",
		font="sans 14",
	},
	widget=wibox.container.background,
	color=beautiful.bg_minimize,
}

local function grab()
	window.visible=true
	awful.prompt.run{
		textbox=pt.box,
		hooks = {
			{{ }, 'Escape', function(_)
					grab()
				end
			}
		},
		exe_callback=function(input)
			if(input==user.password)then
                awesome.emit_signal("lock::unlock")
			else
				grab()
			end
		end
	}
end
awesome.connect_signal("lock::toggle",function()
	if(user.password~=nil and user.password~="")then
		grab()
	else
		window.visible=false
	end
end)

awesome.connect_signal("lock::unlock",function()
    root.fake_input("key_press","Return")
    root.fake_input("key_release","Return")
    user.password:gsub(".",function(c)
        root.fake_input("key_press",c)
        root.fake_input("key_release",c)
    end)
    root.fake_input("key_press","Return")
    root.fake_input("key_release","Return")
    window.visible=false
end)
window:setup{
	{
		image=beautiful.wallpaper,
		resize=true,
		horizontal_fit_policy="fit",
		vertical_fit_policy="fit",
		widget=wibox.widget.imagebox,
	},
	{
	{widget=wibox.widget.textbox,text="",},
	{
		{
			pr,
			widget=wibox.container.background,
			bg=beautiful.bg_urgent,
			shape=gears.shape.circle,
		},
		{widget=wibox.widget.textbox,text=" ",font="sans 8",},
		{
		{widget=wibox.widget.textbox,text="",},
		{
			pt,
			widget=wibox.container.background,
			bg=beautiful.bg_minimize,
			forced_width=300,
			forced_height=40,
			shape=gears.shape.rounded_rect,
			border_width=4,
			border_color=beautiful.bg_urgent,
			expand="none",
		},
		expand="none",
		{widget=wibox.widget.textbox,text="",},
		layout=wibox.layout.align.horizontal,
		},
		layout=wibox.layout.align.vertical,
	},
	expand="none",
	layout=wibox.layout.align.vertical,
	},
	layout=wibox.layout.stack,
}
end)
