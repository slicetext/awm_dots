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

local fairv=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_fairv,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
}
local fvt=awful.tooltip{
	objects={fairv},
	text="Super+Shift+L",
}
fairv:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.fair)
	awesome.emit_signal("layout::toggle")
end)
local fairh=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_fairh,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
}
fairh:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.fair.horizontal)
	awesome.emit_signal("layout::toggle")
end)
local tile=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_tile,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
}
tile:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.tile)
	awesome.emit_signal("layout::toggle")
end)
local tt=awful.tooltip{
	objects={tile},
	text="Super+Alt+L",
}
local floating=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_floating,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal
}
floating:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.floating)
	awesome.emit_signal("layout::toggle")
end)
local ft=awful.tooltip{
	objects={floating},
	text="Super+Shift+Alt+L",
}
local spiral=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_spiral,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
}
spiral:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.spiral)
	awesome.emit_signal("layout::toggle")
end)
local dwindle=wibox.widget{
	{
		widget=wibox.widget.imagebox,
		image=beautiful.layout_dwindle,
		id="icon",
	},
	widget=wibox.container.background,
	bg=beautiful.bg_normal,
}
dwindle:connect_signal("button::press",function()
	awful.layout.set(awful.layout.suit.spiral.dwindle)
	awesome.emit_signal("layout::toggle")
end)

local window = awful.popup({
  ontop = true,
  visible = false,
  border_width=4,
  border_color=beautiful.border_control,
  placement=awful.placement.centered,
  shape=gears.shape.rounded_rect,
  widget={
	  widget=wibox.container.margin,
	  margins=5,
	  {
		  forced_width=dpi(150),
		  forced_height=dpi(100),
		  layout=wibox.layout.grid,
		  expand="none",
		  fairv,
		  fairh,
		  tile,
		  floating,
		  spiral,
		  dwindle,
		  forced_num_cols=3,
		  forced_num_rows=2,
	  },
  },
})
awesome.connect_signal("layout::toggle",function()
	window.visible=not window.visible
end)
