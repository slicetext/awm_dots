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
    forced_width = 50,
    forced_height = 50,
	{
		widget=wibox.widget.imagebox,
		image=gears.color.recolor_image(conf_path.."icons/smile.png",beautiful.fg_normal),
	},
  }
})
local enemy = awful.popup({
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
    forced_width = 50,
    forced_height = 50,
	{
		widget=wibox.widget.imagebox,
		image=gears.color.recolor_image(conf_path.."icons/angry.png",beautiful.fg_normal),
	},
  },
})

local instrux = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  placement=awful.placement.top,
  shape=gears.shape.rounded_rect,
  widget={
	  widget=wibox.container.margin,
	  margins=5,
	  forced_width=200,
	  forced_height=125,
	  {
		  {text="Silly Cube Game",font="sans 16",align="center",widget=wibox.widget.textbox,},
		  {
		  	{text="Super+Arrow Keys to Move",font="sans 8",align="center",widget=wibox.widget.textbox,},
		  	{text="Super+Alt+Arrow Keys to Move Faster",font="sans 8",align="center",widget=wibox.widget.textbox,},
			layout=wibox.layout.align.vertical,
	  	  },
		  {text="Don't let the Angry Silly Cube Catch You!",font="sans 9",align="center",widget=wibox.widget.textbox,},
		  layout=wibox.layout.align.vertical,
	  },
  }
})

local horizontal=rubato.timed({
	duration=1,
	easing=rubato.quadratic,
	subscribed=function(pos)player.x=pos end
})
local vertic=rubato.timed({
	duration=1,
	easing=rubato.quadratic,
	subscribed=function(pos)player.y=pos end
})
local horizontal_e=rubato.timed({
	duration=1/30,
	easing=rubato.quadratic,
	subscribed=function(pos)enemy.x=pos end
})
local vertic_e=rubato.timed({
	duration=1/40,
	easing=rubato.quadratic,
	subscribed=function(pos)enemy.y=pos end
})

awesome.connect_signal("game::right",function()
	horizontal.target=player.x+100
end)
awesome.connect_signal("game::left",function()
	horizontal.target=player.x-100
end)
awesome.connect_signal("game::up",function()
	vertic.target=player.y-100
end)
awesome.connect_signal("game::down",function()
	vertic.target=player.y+100
end)
awesome.connect_signal("game::s_right",function()
	horizontal.target=player.x+400
end)
awesome.connect_signal("game::s_left",function()
	horizontal.target=player.x-400
end)
awesome.connect_signal("game::s_up",function()
	vertic.target=player.y-400
end)
awesome.connect_signal("game::s_down",function()
	vertic.target=player.y+400
end)

awesome.connect_signal("game::toggle",function()
	player.visible=not player.visible
	enemy.visible=not enemy.visible
	instrux.visible=not instrux.visible
	horizontal.target=0
	vertic.target=0
	horizontal_e.target=500
	vertic_e.target=500
	if(player.visible==true)then naughty.notify({title="Silly Cube Game",text="Game Started"}) end
end)
secs=0
e_timer=gears.timer{
	autostart=true,
	timeout=0.1,
	callback=function()
		if(player.visible==true)then
			secs=secs+0.1
		end
		if(secs>=4)then
			horizontal_e.target=player.x
			vertic_e.target=player.y
		end
		if(player.visible==true and (player.x==enemy.x and player.y==enemy.y))then
			naughty.notify({title="Silly Cube Game",text="You lost."})
			awesome.emit_signal("game::toggle")
		end
	end
}
