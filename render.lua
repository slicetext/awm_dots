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

local lib={}

lib.draw=function(win,pixels,color)
	num=0
	for _,i in pairs(pixels)do
		num=num+1
		local w={
			widget=wibox.container.background,
			forced_width=1,
			forced_height=1,
			bg=color,
			point={x=i[1],y=i[2]},
			id=tostring(num),
		}
		win:add(w)
	end
end
lib.draw_rect=function(win,coords,size,color)
	for i=1,size[1],1 do
		for j=1,size[2],1 do
			lib.draw(win,{{i+coords[1],j+coords[2]}},color)
		end
	end
end
lib.draw_img=function(win,coords,img_path,size)
	pic=require(img_path)
	for k=1,#pic,1 do
		local image=require(img_path)[k]
		for i=1,#image.img,size do
			for j=1,#(image.img[i]),1 do
				if(image.img[i][j]~=" ")then
					lib.draw_rect(win,{(j-1)*size+coords[1],(i-1)*size+coords[2]},{size,size},image.color)
				end
			end
		end
	end
end
lib.spawn_win=function(width,height)
local l = wibox.layout {
    layout  = wibox.layout.manual,
	forced_width=width,
	forced_height=height,
}
local window=awful.popup{
	visible=true,
	ontop=false,
	placement=awful.placement.centered,
	widget={
		l,
		layout=wibox.layout.align.horizontal,
	},
}
return l
end

win=lib.spawn_win(500,200)
lib.draw_img(win,{20,20},"awm_img.one",4)

return lib
