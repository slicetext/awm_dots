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
local Gio = require("lgi").Gio
local get_icon=require("lib.util.get_icon")

local list=wibox.widget{
	margins=5,
	--widget=wibox.container.margin,
	layout=require("lib.util.overflow").vertical,
	scrollbar_enabled=true,
	spacing=3,
}

local entry_template=function(name,info,description)
	local temp=wibox.widget{
		{
			image=get_icon(nil,info,info,false),
			resize=true,
			forced_width=dpi(64),
			forced_height=dpi(64),
			widget=wibox.widget.imagebox,
			buttons={
				awful.button({},1, function()
					awful.spawn.with_shell(info)
					awesome.emit_signal("drawer::toggle")
				end),
			},
		},
		{
			markup="<b>"..name.."</b>",
			widget=wibox.widget.textbox,
		},
		{
			text=description,
			widget=wibox.widget.textbox,
			ellipsize="end",
			forced_height=dpi(20),
		},
		layout=wibox.layout.align.vertical,
		widget=wibox.container.background,
	}
	return temp
end

local searchbox=wibox.widget{
	text=" 󰍉 Search",
	id="searchbox",
	widget=wibox.widget.textbox,
}
local drawer=awful.popup{
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  placement=awful.placement.centered,
  shape=gears.shape.rounded_rect,
  widget={
	  forced_width=500,
	  forced_height=500,
	  widget=wibox.container.margin,
	  margins=5,
	  {
		  {
			  searchbox,
			  widget=wibox.container.background,
			  bg=beautiful.bg_minimize,
			  shape=gears.shape.rounded_rect,
		  },
		  list,
		  layout=wibox.layout.align.vertical,
	  },
  }
}
filter=function(input)
	list:reset(list)
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if((string.match(entry:get_executable(),input))or(string.match(entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;"),input)))then
			list:insert(1,entry_template(entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;"),entry:get_executable(),entry:get_description()))
		end
	end
end
search=function()
	awful.prompt.run{
		textbox=searchbox,
		prompt=" :: ",
		exe_callback=function(input)
			filter(input)
		end
	}
end


awesome.connect_signal("drawer::toggle",function()
	drawer.visible=not drawer.visible
	if(drawer.visible==true)then
		search()
	else
		list:reset(list)
	end
end)
