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
local gfs = require("gears.filesystem")
local conf_path = gfs.get_configuration_dir()
local rubato=require "lib.rubato"
local user=require("settings")

visible=true

local temp=wibox.widget{
	text="1 Million Billion Degrees",
	font="sans 30",
	valign="center",
	halign="right",
	widget=wibox.widget.textbox,
}

local sun_img=wibox.widget{
	image=gears.color.recolor_image(conf_path.."icons/sun.png",beautiful.bg_urgent),
	widget=wibox.widget.imagebox,
	halign="left",
}

local player = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
border_color=beautiful.border_control,
  --placement=awful.placement.bottom_right,
  y=dpi(625),
  x=dpi(1140),
  shape=gears.shape.rounded_rect,
  widget = {
    widget = wibox.container.margin,
	margins=5,
    forced_width = 210,
    forced_height = 100,
	{
		{text="Feels Like",valign="top",halign="right",widget=wibox.widget.textbox,},
		temp,
		sun_img,
		layout=wibox.layout.stack,
	},
  }
})
local upA=rubato.timed{
	duration=1/3,
	into=1/6,
	easing=rubato.quadratic,
	subscribed=function(pos) player.x=pos end,
}

awesome.connect_signal("weather::toggle",function()
	if(user.animations==true)then
	visible=not visible
	if(visible==true)then
		player.visible=true
		upA:abort()
		--menu.x=dpi(1210)
		player.y=dpi(625)
		upA.target=dpi(1400)
	else
		player.visible=true
		upA:abort()
		--menu.x=dpi(1190)
		player.y=dpi(405)
		upA.target=dpi(1140)
	end
	else
	player.x=dpi(1130)
	player.visible=not player.visible
end
end)
function get_weather()
	awful.spawn.easy_async_with_shell("ansiweather -l "..user.city.." -u imperial -H true -a false -s true | tr '-' '\\n' | grep 'Feels like: ' | cut -d ':' -f 2",function(out)
		temp.text=""..out
	end)
end
get_weather()
local timer=gears.timer{
	timeout=100,
	autostart=true,
	callback=function()
		get_weather()
	end
}
