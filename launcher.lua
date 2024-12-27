local wibox = require("wibox")
local awful = require("awful")
local Gio = require("lgi").Gio
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local gears = require("gears")

local launcher=wibox{
    screen=awful.screen.focused(),
	width=dpi(200),
	height=dpi(25),
	--y=awful.screen.focused().geometry.y-dpi(30),
	--x=awful.screen.focused().geometry.x,
    x=awful.screen.focused({client=true}).geometry.x+40,
    y=awful.screen.focused({client=true}).geometry.y+awful.screen.focused({client=true}).geometry.height-dpi(35),
	window_type="dock",
	bg=beautiful.bg_normal,
	border_width=1,
	border_color=beautiful.border_control,
	visible=false,
	shape=gears.shape.rounded_rect,
	ontop=true,
}
local promptb = wibox.widget{
	font="sans 18",
	widget=wibox.widget.textbox,
}
local promptt = wibox.widget{
	{
	id="txt",
	font="sans 18",
	widget=wibox.widget.textbox,
	text=" 󰜎 "
	},
	widget=wibox.container.background,
}
local function gen()
	local entries = {}
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if entry:should_show() then
			local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
			table.insert(
				entries,
				{ name = name, appinfo = entry }
			)
		end
	end
	return entries
end
local entries=wibox.widget{
	homogeneous=false,
	expand=true,
	forced_num_cols=1,
	layout=wibox.layout.grid,
	{
		--text=table.concat(gen()),
		widget=wibox.widget.textbox,
	},
}
launcher:setup{
	margins=5,
	widget=wibox.container.margin,
	{
		promptt,
		promptb,
		layout=wibox.layout.align.horizontal,
	},
	layout=wibox.layout.fixed.vertical,
}
function open()
	awful.prompt.run{
		--prompt=" ",
		textbox=promptb,
		exe_callback=function(cmd)
			launcher.visible=false
			awful.spawn.with_shell("bash -ci "..cmd)
		end
	}
end
function copy()
	awful.prompt.run{
		--prompt=" ",
		textbox=promptb,
		exe_callback=function(cmd)
			awesome.emit_signal("copy::result",cmd)
			launcher.visible=false
			promptt.text=" 󰑮 "
		end
	}
end
awesome.connect_signal("launch::toggle",function()
	promptt.txt.text=" 󰑮 "
    launcher.x=awful.screen.focused({client=true}).geometry.x+40
    launcher.y=awful.screen.focused({client=true}).geometry.y+awful.screen.focused({client=true}).geometry.height-dpi(35)
	launcher.visible=not launcher.visible
	if(launcher.visible==true)then
		open()
	end
end)
awesome.connect_signal("copy::toggle",function()
	promptt.txt.text="  "
    launcher.x=awful.screen.focused({client=true}).geometry.x+40
    launcher.y=awful.screen.focused({client=true}).geometry.y+awful.screen.focused({client=true}).geometry.height-dpi(35)
	launcher.visible=not launcher.visible
	if(launcher.visible==true)then
		copy()
	end
end)
