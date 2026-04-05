local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local text = wibox.widget {
    widget = wibox.widget.textbox,
    text = "test",
    valign = "center",
    halign = "center",
}

local notifier = awful.popup {
    ontop = true,
    visible = false,
    placement = awful.placement.top,
    shape = gears.shape.rounded_rect,
    widget = {
        forced_width = 200,
        forced_height = 20,
        widget = wibox.container.margin,
        margins = 2,

        text,
    },
}

local time = 0

gears.timer {
    timeout = 1,
    autostart = true,
    callback = function ()
        if time > 0 then
            time = time - 1
        else
            notifier.visible = false
        end
    end
}

awesome.connect_signal("notifier::notify", function(message)
    text.text = message
    notifier.visible = true
    time = 10
end)
