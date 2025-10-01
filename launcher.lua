local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local gio = require("lgi").Gio
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local beautiful = require("beautiful")
local menubar_utils = require("menubar.utils")

local list = wibox.widget{
    layout = wibox.layout.fixed.vertical,
}

local generate_entry = function(name, description, command, id, icon)
    icon = menubar_utils.lookup_icon(command:lower()) or beautiful.awesome_icon
    return wibox.widget {
        {
            {
                {
                    {
                        widget = wibox.widget.imagebox,
                        image = icon,
                        forced_width = 32,
                        forced_height = 32,
                    },
                    {
                        {
                            widget = wibox.widget.textbox,
                            markup = "<b>"..name.."</b>",
                            font = beautiful.font_big,
                        },
                        {
                            widget = wibox.widget.textbox,
                            text = description,
                            forced_height = dpi(10),
                        },
                        layout = wibox.layout.align.vertical,
                    },
                    layout = wibox.layout.align.horizontal,
                },
                widget = wibox.container.margin,
                margins = 5,
            },
            widget = wibox.container.background,
            id = "bg",
            bg = beautiful.bg_normal,
            shape = gears.shape.rounded_rect,
        },
        widget = wibox.container.margin,
        bottom = 15,
        -- Not awesome property, data for launcher
        command = command,
        identity = id,
    }
end

local prompt = wibox.widget {
    widget = wibox.widget.textbox,
    text = "Search...",
}

local launcher = awful.popup {
    ontop = true,
    visible = false,
    x = 20,
    y = awful.screen.focused().geometry.height - dpi(400) - 55,
    shape = gears.shape.rounded_rect,
    widget = {
        forced_width = dpi(200),
        forced_height = dpi(400),

        {
            {
                list,
                widget = wibox.container.background,
                forced_height = dpi(340);
            },
            {
                {
                    {
                        prompt,
                        widget = wibox.container.margin,
                        left = 5,
                    },
                    widget = wibox.container.background,
                    shape = gears.shape.rounded_rect,
                    bg = beautiful.bg_focus,
                },
                widget = wibox.container.margin,
                top = 5,
                bottom = 5,
            },
            layout=wibox.layout.align.vertical,
        },

        widget = wibox.container.margin,
        margins = 10,
    }
}

local apps = gio.AppInfo.get_all()

local entries = {}
local search  = function(text)
    entries = {}
    list:reset(list)
    local depth = 0
    for _, entry in ipairs(apps) do
        local entry_name = entry:get_name()
        if depth < 6 and string.match(entry_name:lower(), text:lower()) then
            table.insert(entries, generate_entry(entry:get_name(), entry:get_description(), entry:get_executable(), entry:get_id(), entry:get_icon()))
            list:add(entries[#entries])
            depth = depth + 1
        end
    end
end

local selected_index = 1
local prev_entry = function()
    if selected_index > 0 then
        entries[selected_index]:get_children_by_id("bg")[1].bg = beautiful.bg_normal
        selected_index = selected_index - 1
        entries[selected_index]:get_children_by_id("bg")[1].bg = beautiful.bg_focus
    end
end
local next_entry = function()
    if selected_index < #entries then
        entries[selected_index]:get_children_by_id("bg")[1].bg = beautiful.bg_normal
        selected_index = selected_index + 1
        entries[selected_index]:get_children_by_id("bg")[1].bg = beautiful.bg_focus
    end
end

local open = function()
    launcher.visible = true
    local input_old = ""
    list:reset(list)
    local count = 0
    entries = {}
    for _, entry in ipairs(apps) do
        if count <= 6 then
            table.insert(entries, generate_entry(entry:get_name(), entry:get_description(), entry:get_executable(), entry:get_id(), entry:get_icon()))
            list:add(entries[#entries])
            count = count + 1
        end
    end
    awful.prompt.run {
        textbox = prompt,
        done_callback = function()
            launcher.visible = false
        end,
        exe_callback = function ()
            if #entries == 0 then return end
            local app = entries[selected_index]
            -- Handle Flatpaks
            if string.match(app.command, "flatpak") then
                awful.spawn.with_shell("flatpak run "..app.identity:gsub(".desktop", ""))
            else
                awful.spawn.with_shell(app.command)
            end
        end,
        keypressed_callback = function(_, key)
            if key == "Down" then
				next_entry()
			elseif key == "Up" then
				prev_entry()
            elseif key == "Escape" then
                awful.keygrabber.stop()
            end
        end,
        changed_callback = function(input)
            if input ~= input_old then
                search(input)
                if #entries > 0 then
                    entries[selected_index]:get_children_by_id("bg")[1].bg = beautiful.bg_focus
                end
                input_old = input
            end
        end,
    }
end

awesome.connect_signal("launcher::open", function ()
    launcher.screen = awful.screen.focused()
    launcher.x = awful.screen.focused().geometry.x + 20
    launcher.y = awful.screen.focused().geometry.height - dpi(400) - 55
    open()
end)
