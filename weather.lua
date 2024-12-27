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
	font="sans 22",
	--valign="center",
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
  border_width=1,
border_color=beautiful.border_control,
  --placement=awful.placement.bottom_right,
  y=dpi(625),
  x=dpi(1140),
  shape=gears.shape.rounded_rect,
  widget = {
    widget = wibox.container.margin,
	margins=10,
    forced_width = 215,
    forced_height = 100,
	{
	{
		temp,
		sun_img,
		layout=wibox.layout.align.horizontal,
	},
	{text="Feels Like",valign="top",halign="left",widget=wibox.widget.textbox,},
	layout=wibox.layout.fixed.vertical,
  }
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
	if(visible==false)then
		player.visible=true
		upA:abort()
		--menu.x=dpi(1210)
		player.y=dpi(675)
		upA.target=dpi(-500)
	else
		player.visible=true
		upA:abort()
		--menu.x=dpi(1190)
        player.y=awful.screen.focused().geometry.y+awful.screen.focused().geometry.height-dpi(380)
		upA.target=dpi(awful.screen.focused().geometry.x+dpi(40))
	end
	else
	player.x=dpi(1130)
	player.visible=not player.visible
end
end)
function get_weather()
	awful.spawn.easy_async_with_shell("ansiweather -l "..user.city.." -u imperial -H true -a false -s true | sed '/- /s//\\n/g' | grep 'Feels like: ' | cut -d ':' -f 2",function(out)
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
