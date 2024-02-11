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
local client=require("client")
local view=awful.popup {
	visible=false,
    widget = awful.widget.tasklist {
        screen   = screen[1],
        filter   = awful.widget.tasklist.filter.allscreen,
        buttons  = tasklist_buttons,
        style    = {
            shape = gears.shape.rounded_rect,
            align = "center",
			bg=beautiful.bg_normal,
        },
        layout   = {
            spacing         = 5,
            forced_num_rows = 1,
            layout          = wibox.layout.grid.horizontal
        },
        widget_template = {
			widget=wibox.container.margin,
			margins=10,
            {
				{
					{
                	{
                    	id            = "image_roll",
                    	margins       = 4,
                    	forced_height = 64,
                    	forced_width  = 64,
                    	widget        = wibox.widget.imagebox,
						halign="center",
                	},
                	{
                    	id     = "text",
                    	forced_height = 20,
                    	forced_width  = 240,
                    	widget = wibox.widget.textbox,
						placement=awful.placement.bottom,
                	},
					layout=wibox.layout.fixed.vertical,
					expand="none",
					halign="center",
					},
					widget=wibox.container.margin,
					margins=5,
				},
                layout = wibox.layout.align.vertical,
				expand="none",
				forced_height=100,
				forced_width=128,
				widget=wibox.container.margin,
				margins=5,
            },
            id              = "bg",
            widget          = wibox.container.background,
			bg=beautiful.bg_minimize,
			shape=gears.shape.rounded_rect,
            create_callback = function(self, c) --luacheck: no unused
				self.t = c.screen.selected_tag
				self.screenshot=function()
					self:get_children_by_id("image_roll")[1].image=get_icon(c)
					self:get_children_by_id("text")[1].text=c.name
					if(c.active==true)then
						self:get_children_by_id("bg")[1].bg=beautiful.bg_focus
					else
						self:get_children_by_id("bg")[1].bg=beautiful.bg_minimize
					end
				end
				self.screenshot()
				self.buttons={
					awful.button({},1,function()
						c.minimized=false
						c.first_tag:view_only()
					end)
				}
            end,
			update_callback=function(self,c)
				self.t = c.screen.selected_tag
				self.screenshot()
			end
        },
    },
    border_color = "#777777",
    border_width = 2,
    ontop        = true,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect
}
awesome.connect_signal("overview::toggle",function()
	view.visible=not view.visible
end)
