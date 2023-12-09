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
local stopT=wibox.widget{
	text="0",
	align="center",
	font="sans 22",
	widget=wibox.widget.textbox,
}
local stopBT=wibox.widget{
	text="  ",
	font="sans 15",
	align="center",
	widget=wibox.widget.textbox,
}
local stopB=wibox.widget{
	stopBT,
	bg=beautiful.bg_minimize,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
	layout=wibox.layout.align.stacked,
	expand="none",
}
local stopBT2=wibox.widget{
	text=" 󰜉 ",
	font="sans 15",
	align="center",
	widget=wibox.widget.textbox,
}
local stopB2=wibox.widget{
	stopBT2,
	bg=beautiful.bg_minimize,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
	layout=wibox.layout.align.stacked,
	expand="none",
}
local screenT=wibox.widget{
	text=" 󰄀 Screenshot ",
	font="sans 18",
	align="center",
	widget=wibox.widget.textbox,
}
local screenB=wibox.widget{
	screenT,
	bg=beautiful.bg_minimize,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
	layout=wibox.layout.align.stacked,
	expand="none",
}
local editT=wibox.widget{
	text=" 󱁤 Configure ",
	font="sans 18",
	align="center",
	widget=wibox.widget.textbox,
}
local editB=wibox.widget{
	editT,
	bg=beautiful.bg_minimize,
	shape=gears.shape.rounded_rect,
	widget=wibox.container.background,
	layout=wibox.layout.align.stacked,
	expand="none",
}
local copyText=wibox.widget{
	text="",
	align="center",
	widget=wibox.widget.textbox,
}
local window = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  x=dpi(410),
  y=dpi(175),
  shape=gears.shape.rounded_rect,
  widget={
	  widget=wibox.container.margin,
	  margins=5,
	  {
		  forced_width=dpi(500),
		  forced_height=dpi(315),
		  layout=wibox.layout.fixed.vertical,
		  expand="none",
		  spacing=20,
		  {text="Utilities",font="sans 25",align="center",widget=wibox.widget.textbox,},
		  {text=" Stopwatch",font="sans 18",align="center",widget=wibox.widget.textbox,},
		  stopT,
		  {
			{widget=wibox.widget.textbox,text=" "},
			{
		  	stopB,
			{widget=wibox.widget.textbox,text=" "},
		  	stopB2,
			layout=wibox.layout.align.horizontal,
			},
			--{widget=wibox.widget.textbox,text=" "},
			layout=wibox.layout.align.horizontal,
			expand="none",
			layout=wibox.layout.align.horizontal,
			expand="none",
			align="center",
	  	  },
		  copyText,
		  {
		  {widget=wibox.widget.textbox,text=" "},
		  screenB,
		  layout=wibox.layout.align.horizontal,
	  	  },
		  {
		  {widget=wibox.widget.textbox,text=" "},
		  editB,
		  layout=wibox.layout.align.horizontal,
	  	  },
	  },
  },
})
local upA=rubato.timed{
	duration=1/3,
	into=1/6,
	easing=rubato.quadratic,
	subscribed=function(pos) window.x=pos end,
}
local visible=false
awesome.connect_signal("tools::toggle",function()
	visible=not visible
	if(visible==true)then
		window.visible=true
		upA.target=dpi(410)
	else
		window.visible=true
		upA.target=dpi(-550)
	end
end)
awesome.connect_signal("tools::vtoggle",function()
	window.visible=not window.visible
end)
local stopwatch=false
local text=0
time=gears.timer{
	timeout=1,
	autostart=false,
	callback=function()
		text=text+1
		stopT.text=text
	end
}
stopB:connect_signal("button::press",function()
	if(stopwatch==true)then
		time:stop()
		stopBT.text="  "
	else
		time:start()
		stopBT.text="  "
	end
	stopwatch=not stopwatch
end)
stopB2:connect_signal("button::press",function()
	text=0
	stopT.text="0"
end)

screenB:connect_signal("button::press",function()
	awesome.emit_signal("tools::vtoggle")
	awful.spawn(user.screenshot)
	visible=not visible
end)
editB:connect_signal("button::press",function()
	awful.spawn(user.editor.." .config/awesome/settings.lua")
end)
awesome.connect_signal("copy::result",function(result)
	if(result=="")then
		copyText.text=""
	else
		copyText.text="Copied Text: "..result
	end
end)
