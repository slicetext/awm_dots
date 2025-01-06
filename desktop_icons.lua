naughty=require("naughty")
awful=require("awful")
gears=require("gears")
wibox=require("wibox")
beautiful=require("beautiful")
xresources=require("beautiful.xresources")
dpi=xresources.apply_dpi
user=require("settings")
local get_icon=require("lib.util.get_icon")
local s=awful.screen.focused()
local grid=wibox.layout{
	layout=wibox.layout.grid,
    screen=awful.screen.primary,
	forced_num_rows=8,
	orientation="vertical",
	forced_width=user.width,
	homogeneous=true,
	forced_width =s.geometry.width+s.geometry.x-30,
    x=s.geometry.x+30,
	forced_height=s.geometry.height+s.geometry.y,
}

local iconbox=awful.popup{
    screen=awful.screen.primary,
    ontop = false,
  visible = true,
  --placement=awful.placement.top_right,
  y=awful.screen.focused().geometry.y,
  x=awful.screen.focused().geometry.x+30,
  bg="#00000000",
  forced_width =s.geometry.width+s.geometry.x-30,
  forced_height=s.geometry.height+s.geometry.y,
  widget={
	buttons={
		awful.button({},3,function()
			awesome.emit_signal("rclick::toggle")
		end),
	},
	forced_width =s.geometry.width+s.geometry.x-30,
	forced_height=s.geometry.height+s.geometry.y,
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

