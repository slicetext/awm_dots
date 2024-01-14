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

local nottoggle=true
local visible=true
volumeText=wibox.widget({
	text="7%",
	align="right",
	color=beautiful.bg_normal,
	widget=wibox.widget.textbox,
})
local bar = wibox.widget {
    --bar_shape           = gears.shape.rounded_rect,
    bar_height          = 1,
    --bar_color           = beautiful.border_focus,
	bar_border_width    = 1,
    handle_color        = beautiful.bg_normal,
    handle_shape        = gears.shape.circle,
    --handle_border_color = beautiful.border_control,
	handle_color        = beautiful.bg_urgent,
    --handle_border_width = 1,
	handle_width        = 14,
    value               = 25,
    widget              = wibox.widget.slider,
	bar_active_color    = beautiful.bg_urgent,
}
local bright = wibox.widget {
    --bar_shape           = gears.shape.rounded_rect,
    bar_height          = 1,
    --bar_color           = beautiful.border_focus,
	bar_border_width    = 1,
    handle_color        = beautiful.bg_normal,
    handle_shape        = gears.shape.circle,
    --handle_border_color = beautiful.border_control,
	handle_color        = beautiful.bg_urgent,
    --handle_border_width = 1,
	handle_width        = 14,
    value               = 25,
    widget              = wibox.widget.slider,
	bar_active_color    = beautiful.bg_urgent,
}
local wifiT= wibox.widget{
	text="  ",
	font="sans 26",
	widget=wibox.widget.textbox,
}
local wifi = wibox.widget {
		wifiT,
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	shape_border_width=beautiful.button_outline,
	shape_border_color=beautiful.border_control,
}
local notifT= wibox.widget{
	text=" 󰂚 ",
	font="sans 26",
	widget=wibox.widget.textbox,
}
local notif = wibox.widget {
		notifT,
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	shape_border_width=beautiful.button_outline,
	shape_border_color=beautiful.border_control,
}
local toothT= wibox.widget{
	text="  ",
	font="sans 26",
	color=beautiful.fg_urgent,
	widget=wibox.widget.textbox,
}
local tooth = wibox.widget {
		toothT,
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
	shape=gears.shape.rounded_rect,
	shape_border_width=beautiful.button_outline,
	shape_border_color=beautiful.border_control,
}
local batT=wibox.widget {
	text="99%",
	font="sans 8",
	align="center",
	widget=wibox.widget.textbox,
}
local upT=wibox.widget{
	text="uptime",
	widget=wibox.widget.textbox,
}
local set=wibox.widget{
		text=" 󰖷",
		font="sans 10",
		--align="center",
		widget=wibox.widget.textbox,
}
local pow=wibox.widget{
		text=" 󰐥",
		font="sans 10",
		--align="center",
		widget=wibox.widget.textbox,
}
local noti=wibox.widget{
		text=" 󰍡",
		font="sans 10",
		--align="center",
		widget=wibox.widget.textbox,
}
local menu = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  x=dpi(1190),
  y=dpi(605),
  shape=gears.shape.rounded_rect,
  widget={
	widget=wibox.container.margin,
	margins=5,
	{
	forced_width=200,
  	forced_height=110,
	layout=wibox.layout.fixed.vertical,
	expand="none",
	{
		{
			format="%a, %b %d %Y",
			font="sans 10",
			widget=wibox.widget.textclock,
		},
		{text=" ",widget=wibox.widget.textbox,},
		{
			pow,
			set,
			noti,
			layout=wibox.layout.fixed.horizontal,
		},
		layout=wibox.layout.align.horizontal,
	},
	{
		wifi,
		notif,
		tooth,
		spacing=2.5,
		expand="none",
		layout=wibox.layout.align.horizontal,
	},
	batT,
	{
	{
		{
			{text="󰕾",font="sans 18",widget=wibox.widget.textbox,},
			{text=" ",font="sans 6",widget=wibox.widget.textbox,},
			layout=wibox.layout.align.horizontal,
		},
		bar,
		{text="",font="sans 1",widget=wibox.widget.textbox,},
		layout=wibox.layout.align.horizontal,
		expand="center",
		forced_height=15,
	},
	{
		{
			{text="󰃠",font="sans 18",widget=wibox.widget.textbox,},
			{text=" ",font="sans 6",widget=wibox.widget.textbox,},
			layout=wibox.layout.align.horizontal,
		},
		bright,
		{text="",font="sans 1",widget=wibox.widget.textbox,},
		layout=wibox.layout.align.horizontal,
		expand="center",
		forced_height=15,
	},
	layout=wibox.layout.fixed.vertical,
	spacing=5,
	},
  },
  },
})
local upA=rubato.timed{
	duration=1/6,
	into=1/12,
	easing=rubato.quadratic,
	subscribed=function(pos) menu.x=pos end,
}
local tT=""
local tT2=""
local function volume()
	awful.spawn.easy_async_with_shell("sh ~/.config/awesome/volume.sh",function(out)
		volumeText.text="Volume "..out
	end)

	awful.spawn.easy_async_with_shell("sh ~/.config/awesome/vol.sh",function(out)
		bar.value=tonumber(out)
	end)
	awful.spawn.easy_async_with_shell("brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'",function(out)
		bright.value=tonumber(out)
	end)
	awful.spawn.easy_async_with_shell("nmcli radio wifi",function(out)
		if(out:match("enabled")) then
			wifi.bg=beautiful.bg_urgent
		else
			wifi.bg=beautiful.bg_normal
		end
	end)
		if(nottoggle==true) then
			notif.bg=beautiful.bg_urgent
		else
			notif.bg=beautiful.bg_normal
		end
	awful.spawn.easy_async_with_shell("hcitool dev | tail -n +2",function(out)
		if(out~="")then
			tooth.bg=beautiful.bg_urgent
		else
			tooth.bg=beautiful.bg_normal
		end
	end)
	awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/capacity",function(out)
		tT=", Battery at "..string.gsub(out,"\n","").."%"
	end)
	batT.text=tT2..tT
end
volume()
local function upF()
	awful.spawn.easy_async_with_shell("uptime -p | sed 's/[,].*//'",function(out)
	tT2=string.gsub(out,"\n","")
	end)
end
upF()
local v_timer=gears.timer({
	timeout=1,
	autostart=true,
	callback=function()
		volume()
	end,
})
local up=gears.timer({
	timeout=100,
	autostart=true,
	callback=function()
		upF()
	end,
})

bar:connect_signal("property::value", function()
    awful.spawn("pactl set-sink-volume 0 "..tostring(bar.value).."%")
end)
bright:connect_signal("property::value", function()
    awful.spawn("brightnessctl s "..tostring(bright.value).."%")
end)
awesome.connect_signal("dash::toggle",function()
	if(user.animations==true)then
	visible=not visible
	if(visible==true)then
		awesome.emit_signal("music::toggle")
		awesome.emit_signal("weather::toggle")
		menu.visible=true
		--upA:abort()
		--menu.x=dpi(1210)
		upA.target=dpi(1370)
	else
		awesome.emit_signal("music::toggle")
		awesome.emit_signal("weather::toggle")
		menu.visible=true
		--upA:abort()
		--menu.x=dpi(1190)
		upA.target=dpi(1140)
	end
	else
		awesome.emit_signal("music::toggle")
		awesome.emit_signal("weather::toggle")
	menu.x=dpi(1190)
	menu.visible=not menu.visible
	end
end)
wifi:connect_signal("button::press",function()
	awful.spawn.easy_async_with_shell("nmcli radio wifi",function(out)
		if(out:match("enabled"))then
			volume()
			awful.spawn("nmcli radio wifi off")
			wifiT.text=" 󰖪 "
		else
			volume()
			awful.spawn("nmcli radio wifi on")
			wifiT.text="  "
		end
	end)
end)
notif:connect_signal("button::press",function()
	naughty.toggle()
	nottoggle=not nottoggle
	volume()
	if(nottoggle==false)then
		notifT.text="  "
	else
		notifT.text="  "
	end
end)
tooth:connect_signal("button::press",function()
	awful.spawn.easy_async_with_shell("hcitool dev | tail -n +2",function(out)
		if(out~="")then
			awful.spawn("rfkill block bluetooth")
			volume()
		else
			awful.spawn("rfkill unblock bluetooth")
			volume()
		end
	end)
end)
set:connect_signal("button::press",function()
	if(user.animations==true)then
		awesome.emit_signal("tools::toggle")
	else
		awesome.emit_signal("tools::vtoggle")
	end
end)
pow:connect_signal("button::press",function()
	awesome.emit_signal("power::toggle")
end)
noti:connect_signal("button::press",function()
	awesome.emit_signal("notif::toggle")
end)

awesome.connect_signal("dash::false",function()
	if(visible==false)then
		awesome.emit_signal("music::toggle")
		awesome.emit_signal("weather::toggle")
		menu.visible=true
		--upA:abort()
		--menu.x=dpi(1210)
		upA.target=dpi(1370)
	end
end)
