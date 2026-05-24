local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local highlight = awful.popup {
    ontop = true,
    visible = false,
    shape=gears.shape.star,
    border_width = 5,
    border_color=beautiful.bg_normal,
    x = 20,
    y = 20,
    input_passthrough = true;
    widget = {
        {
            widget= wibox.container.margin,
            margin =50,
            {
                widget=wibox.widget.textbox,
                text=" ",
            },
        },
        widget = wibox.container.background,
        bg = beautiful.bg_urgent,
        forced_width = dpi(80),
        forced_height = dpi(80),
    }
}

local toggled = false
awesome.connect_signal("cursor::hl", function ()
    toggled = not toggled
    highlight.visible = toggled
end)
gears.timer {
    timeout = 0.1,
    autostart = true,
    call_now = true,
    callback = function ()
        local pos = mouse.coords()
        highlight.x = pos.x
        highlight.y = pos.y
    end
}
