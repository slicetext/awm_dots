naughty=require("naughty")
awful=require("awful")
gears=require("gears")
wibox=require("wibox")
beautiful=require("beautiful")
xresources=require("beautiful.xresources")
dpi=xresources.apply_dpi
user=require("settings")
local get_icon=require("lib.util.get_icon")
local rubato=require "lib.rubato"

local apps=wibox.layout{
	layout=wibox.layout.flex.horizontal,
}
local pinned=wibox.layout{
	layout=wibox.layout.flex.horizontal,
}

apart=wibox.widget{
	widget=wibox.container.margin,margins=5,
	{widget=wibox.container.background,bg=beautiful.bg_minimize,forced_width=5,forced_height=50,shape=gears.shape.rounded_rect},
	visible=false,
}
dock_widget=wibox.layout{
	pinned,
	apart,
	apps,
	layout=wibox.layout.fixed.horizontal,
}
local dock = awful.popup({
  ontop = true,
  visible = false,
  --border_width=4,
  --border_color=beautiful.border_control,
  bg=beautiful.bg_focus,
  shape=gears.shape.rounded_rect,
  placement=awful.placement.bottom,
  widget={
	forced_height=dpi(48),
	layout=wibox.layout.align.horizontal,
	dock_widget,
  }
})
local hot = awful.popup({
  ontop = true,
  visible = true,
  shape=gears.shape.rounded_rect,
  placement=awful.placement.bottom,
  bg="#00000000",
  widget={
	forced_height=dpi(user.gap),
	forced_width=dpi(400),
	layout=wibox.layout.align.horizontal,
  }
})

gen_icon=function(icon,app)
	local widget=wibox.widget{
		widget=wibox.container.margin,
		margins=1,
		{
			image=get_icon(nil,icon,icon,false),
			widget=wibox.widget.imagebox,
			forced_width=48,
			forced_height=48,
		},
		buttons={
			awful.button({},1,function()
				awful.spawn.with_shell(app)
			end),
		}
	}
	return widget
end
gen_icon2=function(i)
	local widget=wibox.widget{
		widget=wibox.container.margin,
		margins=1,
		{
			image=get_icon(nil,i.class,i.class,false),
			widget=wibox.widget.imagebox,
			forced_width=48,
			forced_height=48,
		},
		buttons={
			awful.button({},1,function()
				if(app==client.focus)then
					i.minimized=not i.minimized
				else
					client.focus=i
				end
			end),
		}
	}
	return widget
end
g_c=function()
	local clients = mouse.screen.selected_tag and mouse.screen.selected_tag:clients() or {}
	return clients
end
refresh=function()
	apps:reset(apps)
	num_c=0
	for _,i in ipairs(g_c())do
		num_c=num_c+1
	end
	if(num_c>0)then
		apart.visible=true
		apps.visible=true
	else
		apart.visible=false
	end
	for _,i in ipairs(g_c())do
		apps:add(gen_icon2(i))
	end
	--dock_widget:add(3,apps)
end
refresh()

for _,i in pairs(user.dock_pinned)do
	pinned:add(gen_icon(i[1],i[2]))
end

local dock_pos=rubato.timed{
	duration=1/20,
	subscribed=function(x)
		dock.y=x
	end,
}
client.connect_signal("focus", function() refresh() end)
client.connect_signal("property::minimized", function() refresh() end)
client.connect_signal("property::maximized", function() refresh() end)
client.connect_signal("manage", function() refresh() end)
client.connect_signal("unmanage", function() refresh() end)
tag.connect_signal("property::selected", function()
	refresh()
	dock.visible=false
end)

dock_pos.target=user.height+60
hot:connect_signal("mouse::enter",function()
	dock.visible=true
	dock_pos.target=user.height-60
end)
dock:connect_signal("mouse::leave",function()
	dock.visible=true
	dock_pos.target=user.height+60
end)
