local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

-- Battery Percentage
local battery_cap = "/sys/class/power_supply/BAT0/capacity"
local battery_status = "/sys/class/power_supply/BAT0/status"
gears.timer {
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = function()
        -- Battery Percentage
        local percentage = awful.spawn.easy_async_with_shell("cat "..battery_cap, function (out)
            awesome.emit_signal("battery::capacity", out)
        end)
        awesome.emit_signal("battery::capacity", percentage)
        -- Battery Status
        local status = awful.spawn.easy_async_with_shell("cat "..battery_status, function (out)
            awesome.emit_signal("battery::status", out)
        end)
    end,
}

-- Volume
local volume_level = "awk -F\"[][]\" '/dB/ { print $2 }' <(amixer sget Master)"
local send_volume = function ()
    local volume = awful.spawn.easy_async_with_shell(volume_level, function (out)
        awesome.emit_signal("volume::level", out)
    end)
end
gears.timer {
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = function ()
        -- Volume Level
        send_volume()
    end
}
-- Modify Volume
awesome.connect_signal("volume::up", function ()
    awful.spawn.easy_async_with_shell("amixer -D pulse sset Master 5%+")
    send_volume()
end)
awesome.connect_signal("volume::down", function ()
    awful.spawn.easy_async_with_shell("amixer -D pulse sset Master 5%-")
    send_volume()
end)
awesome.connect_signal("volume::set", function (volume)
    awful.spawn.easy_async_with_shell("amixer sset Master "..tostring(volume).."%")
    send_volume()
end)

-- Wifi
local wifi_strength = "nmcli -f IN-USE,SIGNAL device wifi | grep '*' | sed 's/ //g' | sed 's/\\*//g'"
gears.timer {
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = function ()
        local strength = awful.spawn.easy_async_with_shell(wifi_strength, function (out)
            awesome.emit_signal("wifi::strength", out:gsub("\n", ""))
        end)
    end
}

-- Music
awesome.connect_signal("playerctl::prev", function ()
    awful.spawn.easy_async_with_shell("playerctl previous", function ()end)
end)

awesome.connect_signal("playerctl::pause", function ()
    awful.spawn.easy_async_with_shell("playerctl play-pause", function ()end)
end)

awesome.connect_signal("playerctl::next", function ()
    awful.spawn.easy_async_with_shell("playerctl next", function ()end)
end)

local title_cmd  = "playerctl metadata title"
local artist_cmd = "playerctl metadata artist"
local artUrl_cmd = "playerctl metadata mpris:artUrl"
gears.timer {
    timeout = 1,
    autostart = true,
    call_now = true,
    callback = function ()
        local title  = awful.spawn.easy_async_with_shell(title_cmd, function (out)
            awesome.emit_signal("playerctl::title", out:gsub("\n", ""))
        end)
        local artist = awful.spawn.easy_async_with_shell(artist_cmd, function (out)
            awesome.emit_signal("playerctl::artist", out:gsub("\n", ""))
        end)
        local artUrl = awful.spawn.easy_async_with_shell(artUrl_cmd, function (out)
            awesome.emit_signal("playerctl::artUrl", out:gsub("\n", ""))
        end)
    end
}
