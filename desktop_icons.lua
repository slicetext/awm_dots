naughty=require("naughty")
awful=require("awful")
gears=require("gears")
wibox=require("wibox")
beautiful=require("beautiful")
xresources=require("beautiful.xresources")
dpi=xresources.apply_dpi
user=require("settings")
local get_icon=require("lib.util.get_icon")

local grid
awful.screen.connect_for_each_screen(function(s)
grid=wibox.layout{
	layout=wibox.layout.grid,
    screen=awful.screen.primary,
	forced_num_rows=8,
	orientation="vertical",
	forced_width=user.width,
	homogeneous=true,
	forced_width =s.geometry.width+s.geometry.x-30,
	forced_height=s.geometry.height+s.geometry.y,
}
end)

local iconbox=awful.popup{
  ontop = false,
  visible = true,
  placement=awful.placement.top_right,
  bg="#00000000",
  widget={
	buttons={
		awful.button({},3,function()
			awesome.emit_signal("rclick::toggle")
		end),
	},
	forced_width=user.width-40,
	forced_height=user.height,
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
num=0
n_col=1
for _ , i in pairs(user.desktop_icons)do
	if(i[1]~="")then
		grid:add(create_icon(i))
	else
		grid:add({forced_height=64,forced_width=64,layout=wibox.layout.manual,})
	end
	if(num+1==8)then
		grid:insert_column(n_col+1)
		n_col=n_col+1
		num=-1
	end
	num=num+1
end
