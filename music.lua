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

local visible=true

local pause = wibox.widget({
  {
  	text = " 󰐎 ",
	font = "sans 14",
	id   = "txt",
  valign="bottom",
  	widget = wibox.widget.textbox,
  },
  shape=gears.shape.rounded_rect,
  widget=wibox.container.background,
  valign="bottom",
})

local  nexts = wibox.widget({
  {
  	text = " 󰒭 ",
	font = "sans 14",
  valign="bottom",
  	widget = wibox.widget.textbox,
  },
  shape=gears.shape.rounded_rect,
  widget=wibox.container.background,
  valign="bottom",
})

local  prevs = wibox.widget({
  {
  	text = " 󰒮 ",
	font = "sans 14",
  valign="bottom",
  	widget = wibox.widget.textbox,
  },
  shape=gears.shape.rounded_rect,
  widget=wibox.container.background,
  valign="bottom",
})
local song = wibox.widget({
	text = "Song",
	ellipsize="end",
	align= "center",
	widget=wibox.widget.textbox,
})
local artist = wibox.widget({
	text = "Artist",
	align= "center",
	ellipsize="end",
	font = "sans 7",
	widget=wibox.widget.textbox,
})
local cover = wibox.widget({
	widget=wibox.widget.imagebox,
	visible=true,
	resize=true,
	clip_shape=gears.shape.rounded_rect,
	align="center",
    bg=beautiful.bg_urgent,
})
local player = awful.popup({
  ontop = true,
  visible = false,
  border_width=1,
border_color=beautiful.border_control,
  --placement=awful.placement.bottom_right,
  y=dpi(605),
  x=dpi(1130),
  shape=gears.shape.rounded_rect,
  widget = {
    widget = wibox.container.margin,
	margins=10,
    forced_width = 215,
    forced_height = 100,
	{
		widget=wibox.container.margin,
		{
		layout=wibox.layout.align.horizontal,
			--{widget=wibox.widget.textbox,text=" "},
			{
				{widget=wibox.widget.textbox,text=" "},
				cover,
                bg=beautiful.bg_urgent,
				{widget=wibox.widget.textbox,text=" "},
				layout=wibox.layout.align.horizontal,
				expand="none",
			},
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				{widget=wibox.widget.textbox,text=" "},
				{
					{widget=wibox.widget.textbox,text=" ",forced_height=0.1},
					song,
					--{widget=wibox.widget.textbox,text=" "},
					artist,
					layout=wibox.layout.align.vertical,
				},
    			{
    				layout = wibox.layout.align.horizontal,
					expand="none",
					prevs,
    				pause,
					nexts,
    			},
				layout = wibox.layout.align.vertical,
			},
		},
	},
	},
},
})

local upA=rubato.timed{
	duration=1/3,
	into=1/6,
	easing=rubato.quadratic,
	subscribed=function(pos) player.x=pos end,
}
pause:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl play-pause \
  ")
end)
pause:connect_signal("mouse::enter",function()
	pause.bg=beautiful.bg_minimize
end)

pause:connect_signal("mouse::leave",function()
	pause.bg=beautiful.bg_normal
end)

prevs:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl previous \
  ")
end)
prevs:connect_signal("mouse::enter",function()
	prevs.bg=beautiful.bg_minimize
end)

prevs:connect_signal("mouse::leave",function()
	prevs.bg=beautiful.bg_normal
end)
nexts:connect_signal("button::press", function()
  awful.spawn.with_shell("\
  playerctl next \
  ")
end)

nexts:connect_signal("mouse::enter",function()
	nexts.bg=beautiful.bg_minimize
end)

nexts:connect_signal("mouse::leave",function()
	nexts.bg=beautiful.bg_normal
end)
awesome.connect_signal("music::toggle",function()
	if(user.animations==true)then
	visible=not visible
	if(visible==true)then
		player.visible=true
		upA:abort()
		--menu.x=dpi(1210)
		player.y=dpi(620)
		upA.target=dpi(-500)
	else
		player.visible=true
		upA:abort()
		--menu.x=dpi(1190)
        player.y=awful.screen.focused().geometry.y+awful.screen.focused().geometry.height-dpi(265)
		upA.target=dpi(awful.screen.focused().geometry.x+dpi(40))
	end
	else
	player.x=dpi(1130)
	player.visible=not player.visible
end
end)
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

old=""
new=""
local function titles()	
	awful.spawn.easy_async_with_shell("playerctl metadata title",function(out)
	if(out=="") then
		song.text="Nothing is Playing"
	else
		song.text=out
	end
	end)
	awful.spawn.easy_async_with_shell("playerctl metadata artist",function(out)
	if(out=="") then
		artist.text="Unknown Artist"
	else
		artist.text=out
	end
	end)
	awful.spawn.easy_async_with_shell("playerctl status",function(out)
	if(out=="Playing\n") then
		pause.txt.text=" 󰏤 "
	else
		pause.txt.text=" 󰐊 "
	end
	end)
	awful.spawn.easy_async_with_shell("playerctl metadata mpris:artUrl",function(out)
		new=out
		if(old~=out)then
			awful.spawn.with_shell("sh ~/.config/awesome/curlArt.sh")
			sleep(0.1)
			cover.image=gears.surface.load_uncached("/home/owner/.config/awesome/cache/album.png")
		old=out
		end
	end)
end
local default=false
local timer=gears.timer{
	timeout=1,
	autostart=true,
	callback=function()
		titles()
		awful.spawn.easy_async_with_shell("playerctl status",function(out)
			if((out==""or old=="")and (default==false))then
				cover.image=gears.color.recolor_image(gears.surface.load_uncached(conf_path.."/icons/music.jpeg"),beautiful.bg_urgent)
				default=true
			else
				default=false
				--cover.image=gears.surface.load_uncached(conf_path.."/cache/album.png")
			end
		end)
	end,
}
