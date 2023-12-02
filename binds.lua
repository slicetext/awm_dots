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
		  forced_width=dpi(500),
		  forced_height=dpi(345),
		  layout=wibox.layout.fixed.vertical,
		  expand="center",
		  spacing=20,
		  {
			  text="Super+Enter: Open Terminal",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+D: Open Run Prompt",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+Shift+Q: Close Active Window",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+Shift+E: Close Awesome Window Manager",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+(Number 1-4): Switch to the Workspace of the Number",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+Shift+(Number 1-4): Move Active Window to the Workspace of the Number",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+J: Move to the Next Window",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+K: Move to the Previous Window",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+F: Make the Current Window Fullscreen",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+/: Toggle this Window",
			  widget=wibox.widget.textbox,
		  },
		  {
			  text="Super+Ctrl+R: Restart Awesome Window Manager",
			  widget=wibox.widget.textbox,
		  },
	  },
  },
})
awesome.connect_signal("binds::toggle",function()
	window.visible=not window.visible
end)
