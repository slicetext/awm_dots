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

local ballx=0
local bally=0
local ballx_speed=1
local bally_speed=1

local screen_width=840
local screen_height=400

local paddle1x=20
local paddle1y=0
local paddle1height=120

local score=0

ball=wibox.widget{
	point={x=ballx,y=bally},
	widget=wibox.container.background,
	forced_width=20,
	forced_height=20,
	bg=beautiful.bg_focus,
}
paddle1=wibox.widget{
	point={x=paddle1x,y=paddle1y},
	widget=wibox.container.background,
	forced_width=20,
	forced_height=paddle1height,
	bg=beautiful.bg_minimize,
}
local score_w=wibox.widget{
	text=score,
	widget=wibox.widget.textbox,
	font="sans 14",
}
local score_w_m=wibox.widget{
	score_w,
	widget=wibox.container.margin,
	margins=2,
	align="right",
	valign="top",
	point=awful.placement.left,
}
local l = wibox.layout {
    layout  = wibox.layout.manual,
	ball,
	paddle1,
	buttons={
		awful.button({},4,function()
			awesome.emit_signal("pong::up")
		end),
		awful.button({},5,function()
			awesome.emit_signal("pong::down")
		end),
	}
}
awesome.connect_signal("pong::up",function()
	if(paddle1y-20>=0)then
		l:move_widget(paddle1,{x=paddle1x,y=paddle1y-20})
		paddle1y=paddle1y-20
	end
end)
awesome.connect_signal("pong::down",function()
	if(paddle1y+paddle1height+20<=screen_height)then
		l:move_widget(paddle1,{x=paddle1x,y=paddle1y+20})
		paddle1y=paddle1y+20
	end
end)

local game=awful.popup{
	visible=false,
	ontop=true,
    border_width=4,
    border_color=beautiful.border_control,
	placement=awful.placement.centered,
	widget={
		forced_width=screen_width,
		forced_height=screen_height,
		{text="Scroll to Control Paddle",widget=wibox.widget.textbox,align="center",point=awful.placement.top,font="sans 12",},
		score_w_m,
		l,
		layout=wibox.layout.manual,
		id="main",
	},
}

local update=gears.timer{
	autostart=true,
	timeout=0.1/1.5,
	callback=function()
		ballx=ballx+ballx_speed*20
		bally=bally+bally_speed*20
		l:move_widget(ball,{x=ballx,y=bally})
		if((screen_width/20==ballx/20+1 and ballx_speed>0)or(0==ballx/20 and ballx_speed<0))then
			ballx_speed=-ballx_speed
		end
		if((paddle1x/20+1==ballx/20 or paddle1x/20==ballx/20) and (bally/20>paddle1y/20 and bally/20<paddle1y+paddle1height/20))then
			ballx_speed=-ballx_speed
			score=score+1
			score_w.text=score
		end
		if((screen_height/20==bally/20+1 and bally_speed>0)or(0==bally/20 and bally_speed<0))then
			bally_speed=-bally_speed
		end
		if(score>=10 and paddle1x-20==0)then
			paddle1x=paddle1x+20
			l:move_widget(paddle1,{paddle1x,paddle1y})
		end
	end,
}
awesome.connect_signal("pong::toggle",function()
	l:move_widget(ball,{x=80,y=20})
	ballx=80
	bally=20
	score=0
	score_w.text=score
	game.visible=not game.visible
end)
