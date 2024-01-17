naughty=require("naughty")
awful=require("awful")
gears=require("gears")
wibox=require("wibox")
beautiful=require("beautiful")
xresources=require("beautiful.xresources")
dpi=xresources.apply_dpi
user=require("settings")
local get_icon=require("lib.util.get_icon")

local grid=wibox.layout{
	layout=wibox.layout.grid,
}

local iconbox=awful.popup{
  ontop = false,
  visible = true,
  placement=awful.placement.maximize,
  bg="#00000000",
  widget={
	{
		grid,
		layout=wibox.layout.manual,
  	},
	widget=wibox.container.margin,
	margins=5,
  },
}

create_icon=function(i)
	local icon_tb=wibox.widget{
		widget=wibox.container.margin,
		margins=4,
		buttons={
			awful.button({},1,function()
				awful.spawn.with_shell(i[2])
			end),
		},
		{
			layout=wibox.layout.align.vertical,
			{
				image=get_icon(nil,i[3],i[3],false),
				widget=wibox.widget.imagebox,
				forced_width=64,
				forced_height=64,
			},
			{
				markup="<b>"..i[1].."</b>",
				widget=wibox.widget.textbox,
				align="center",
			},
		},
	}
	return icon_tb
end

for _ , i in pairs(user.desktop_icons)do
	grid:add(create_icon(i))
end
