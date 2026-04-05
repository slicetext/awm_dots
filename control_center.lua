local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local beautiful = require("beautiful")

-- icon_on: string
-- icon_off: string
-- check_state: function with no args,  returns bool
-- callback: function with one boolean arg, state, returns nothing
local toggle_button = function (icon_on, icon_off, check_state, callback)
    local button = wibox.widget {
        widget = wibox.container.margin,
        margins = 5,
        {
            widget = wibox.container.background,
            bg = beautiful.bg_focus,
            shape = gears.shape.rounded_rect,
            id = "bg",
            {
                {
                    widget = wibox.widget.textbox,
                    text = icon_off,
                    id = "text",
                    font = beautiful.font_giant,
                },
                widget = wibox.container.margin,
                left = 60,
                right = 60,
                top = 15,
                bottom = 15,
            },
        },
        state = false,
    }
    local update_btn = function()
        if button.state then
            button:get_children_by_id("bg")[1].bg = beautiful.bg_minimize
            button:get_children_by_id("text")[1].text = icon_on
        else
            button:get_children_by_id("bg")[1].bg = beautiful.bg_focus
            button:get_children_by_id("text")[1].text = icon_off
        end
    end
    button:connect_signal("button::press", function ()
        button.state = not button.state
        callback(button.state)
        update_btn()
    end)

    gears.timer{
        timeout = 1,
        autostart = true,
        call_now = true,
        callback = function ()
            check_state(button)
            update_btn()
        end
    }

    return button
end

local slider = function(icon, check_state, callback)
    local slide = wibox.widget {
        widget = wibox.container.margin,
        margins = 5,
        {
            {
                {
                    widget = wibox.widget.textbox,
                    text = icon,
                    font = beautiful.font_huge,
                },
                widget = wibox.container.margin,
                right = 10,
            },
            {
                id = "bar",
                widget = wibox.widget.slider,

                bar_shape = gears.shape.rounded_bar,
                bar_height          = 5,
                bar_color           = beautiful.bg_focus,
                handle_color        = beautiful.bg_minimize,
                handle_shape        = gears.shape.circle,
                handle_width        = 20,
                value               = 25,
                maximum             = 100,
                minimum             = 0,
                forced_height = 10,
            },
            layout = wibox.layout.align.horizontal,
        },
    }
    gears.timer{
        timeout = 10,
        autostart = true,
        call_now = true,
        callback = function ()
            check_state(slide)
        end
    }
    slide:get_children_by_id("bar")[1]:connect_signal("property::value", function (_, new_value)
        callback(new_value)
    end)
    return slide
end


local paused = false

local pause_btn = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            text = "󰏤",
            font = beautiful.font_huge,
            id = "text"
        },
        widget = wibox.container.margin,
        margins = 5,
    },
    widget = wibox.container.background,
    bg = beautiful.bg_normal,
    shape = gears.shape.rounded_rect,
}
pause_btn:connect_signal("mouse::enter", function ()
    pause_btn.bg = beautiful.bg_minimize
end)
pause_btn:connect_signal("mouse::leave", function ()
    pause_btn.bg = beautiful.bg_normal
end)
local update_pause = function ()
    if paused == true then
        pause_btn:get_children_by_id('text')[1].text = "󰐊"
    else
        pause_btn:get_children_by_id('text')[1].text = "󰏤"
    end
end

pause_btn:connect_signal("button::press", function ()
    awesome.emit_signal("playerctl::pause")
    paused = not paused
    update_pause()
end)
local prev_btn = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            text = "󰒮",
            font = beautiful.font_huge,
        },
        widget = wibox.container.margin,
        margins = 5,
    },
    widget = wibox.container.background,
    bg = beautiful.bg_normal,
    shape = gears.shape.rounded_rect,
    fixed_width = 32,
    fixed_height = 32,
    vexpand = "none",
    hexpand = "none",
    buttons = {
        awful.button({ }, 1, function ()
            awesome.emit_signal("playerctl::prev")
        end)
    }
}
prev_btn:connect_signal("mouse::enter", function ()
    prev_btn.bg = beautiful.bg_minimize
end)
prev_btn:connect_signal("mouse::leave", function ()
    prev_btn.bg = beautiful.bg_normal
end)
local next_btn = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            text = "󰒭",
            font = beautiful.font_huge,
        },
        widget = wibox.container.margin,
        margins = 5,
    },
    widget = wibox.container.background,
    bg = beautiful.bg_normal,
    shape = gears.shape.rounded_rect,
    buttons = {
        awful.button({ }, 1, function ()
            awesome.emit_signal("playerctl::next")
            paused = false
            update_pause()
        end)
    }
}
next_btn:connect_signal("mouse::enter", function ()
    next_btn.bg = beautiful.bg_minimize
end)
next_btn:connect_signal("mouse::leave", function ()
    next_btn.bg = beautiful.bg_normal
end)

local title  = wibox.widget {
    widget = wibox.widget.textbox,
    text = "No Song Playing",
    font = beautiful.font_mid,
    halign = "center",
}

awesome.connect_signal("playerctl::title", function (out)
    title.text = out
end)

local artist = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    font = beautiful.font_mid,
    halign = "center",
}

awesome.connect_signal("playerctl::artist", function (out)
    artist.text = out
end)

local cover = wibox.widget {
    widget = wibox.widget.imagebox,
    clip_shape = gears.shape.rounded_rect,
    forced_width = 256,
    vexpand = "none",
    halign = "center",
}

awesome.connect_signal("playerctl::artUrl", function (out)
    cover.image = out:sub(6)
end)

local control_center = awful.popup {
    ontop = true,
    visible = false,
    x = awful.screen.focused().geometry.width  - dpi(600) - 20,
    y = awful.screen.focused().geometry.height - dpi(350) - 55,
    shape = gears.shape.rounded_rect,
    widget = {
        forced_width = dpi(600),
        forced_height = dpi(350),
        widget = wibox.container.margin,
        margins = 10,

        {
            {
                layout = wibox.layout.fixed.vertical,
                cover,
                title,
                artist,
                {
                    {
                        prev_btn,
                        pause_btn,
                        next_btn,
                        layout = wibox.layout.fixed.horizontal,
                        spacing = 10,
                    },
                    align = "center",
                    widget = wibox.container.place,
                }
            },
            {
                layout = wibox.layout.fixed.vertical,
                {
                    layout = wibox.layout.grid,
                    forced_num_rows = 1,
                    forced_num_cols = 2,

                    toggle_button("󰤨", "󰤭", function (self)
                        local result;
                        awful.spawn.easy_async_with_shell("nmcli radio wifi", function (out)
                            if(string.find(out, "enabled") ~= nil)then
                                self.state = true
                            else
                                self.state = false
                            end
                        end)
                        return result
                    end, function (state)
                    if(state) then
                        awful.spawn.easy_async_with_shell("nmcli radio wifi on", function ()end)
                    else
                        awful.spawn.easy_async_with_shell("nmcli radio wifi off", function()end)
                    end
                    end),
                    toggle_button("", "󰂚", function (self)
                        self.state = naughty.is_suspended()
                    end, function (state)
                        naughty.toggle()
                    end),
                },
                slider("󰕾", function (self)
                    awesome.connect_signal("volume::level", function (vol)
                        -- self:get_children_by_id("bar")[1].value = tonumber(vol:sub(1, -3))
                    end)
                end, function (val)
                    awesome.emit_signal("volume::set", val)
                end),
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = 5,
        }
    },
}

awesome.connect_signal("control_center::toggle", function()
    control_center.visible = not control_center.visible
end)
