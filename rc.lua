-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.fair,
        awful.layout.suit.floating,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        bg     = beautiful.bg_normal,
        widget = {
            {
                image  = beautiful.wallpaper,
                resize = true,
                widget = wibox.widget.imagebox,
                clip_shape = gears.shape.rounded_rect,
                horizontal_fit_policy = "fit",
            },
            valign = "center",
            halign = "center",
            widget = wibox.container.margin,
            bottom = 45,
            top = 10,
            left = 10,
            right = 10,
        }
    }
end)
-- }}}

local systray = wibox.widget {
    widget = wibox.widget.systray,
    visible = false,
}
local systray_btn = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    toggled = false,
}
systray_btn:connect_signal("button::press", function()
    systray_btn.toggled = not systray_btn.toggled;
    if(systray_btn.toggled) then
        systray_btn.text = ""
        systray.screen = awful.screen.focused({mouse=true})
        systray.visible = true
    else
        systray_btn.text = ""
        systray.visible = false
    end
end)
-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget {
    {
        {
            widget = wibox.widget.textclock,
            format = "    %a %b %e   |  %l:%M %P    ",
        },
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        bg = beautiful.bg_focus,
    },
    widget = wibox.container.margin,
    margins = 5,
}

textclock_btn = wibox.widget {
}

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ " ", " ", " ", " " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        }
    }

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        style = {
            shape = gears.shape.rounded_rect,
        },
        widget_template = {
            widget = wibox.container.margin,
            margins = 5,
            width = 40,
            {
                widget = wibox.container.background,
                id = "bg",
                shape = gears.shape.squircle,
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                        forced_width = 15,
                        halign = "center",
                    },
                    widget = wibox.container.margin,
                    margins = 1,
                    left = 5,
                    right = 5,
                },
            },
            create_callback = function(self, tag)
                self.update = function ()
                    if(tag.selected)then
                        self:get_children_by_id('bg')[1].bg = beautiful.bg_urgent
                    elseif(#tag:clients() > 0)then
                        self:get_children_by_id('bg')[1].bg = beautiful.bg_minimize
                    else
                        self:get_children_by_id('bg')[1].bg = beautiful.bg_normal
                    end
                end
                self.update()
            end,
            update_callback = function(self)
                self.update()
            end
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({ }, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
        },
        style = {
            shape = gears.shape.rounded_rect,
        },
        layout = {
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    awful.widget.clienticon,
                    widget = wibox.container.margin,
                    margins = 5,
                },
                id = "background_role",
                widget = wibox.container.background,
                fixed_width = 70,
                expand = false,
            },
            widget = wibox.container.margin,
            margins = 5,
        },
    }

    awesome.connect_signal("systray::toggle",function ()
        s.mySystray.visible = not s.mySystray.visible
        s.mySystray.screen=awful.screen.focused()
    end)

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "bottom",
        screen   = s,
        height   = 40,
        widget   = {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                {
                    widget = wibox.container.margin,
                    margins = 5,
                    {
                        widget = wibox.container.background,
                        shape = gears.shape.rounded_rect,
                        bg = beautiful.bg_focus,
                        {
                            widget = wibox.widget.textbox,
                            text = "",
                            font = beautiful.font_huge,
                            halign = "center",
                            forced_width = 30,
                        },
                        buttons = {
                            awful.button({}, 1, function ()
                                awesome.emit_signal("launcher::open")
                            end)
                        },
                    },
                },
                {
                    {
                        s.mytaglist, -- Middle widget
                        widget = wibox.container.background,
                        bg = beautiful.bg_focus,
                        shape = gears.shape.rounded_rect,
                    },
                    widget = wibox.container.margin,
                    margins = 5,
                },
                s.mypromptbox,
            },
            s.mytasklist,
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                systray_btn,
                {
                    systray,
                    widget = wibox.container.margin,
                    margins = 10,
                },
                mytextclock,
                {
                    s.mylayoutbox,
                    widget = wibox.container.margin,
                    margins = 10,
                },
            },
        }
    }
end)

-- }}}

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "d",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "a", function()
        awesome.emit_signal("launcher::open")
    end,
              {description = "show the launcher", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "m",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
            awful.key({modkey},"`", function ()
                awesome.emit_signal("taglist::update")
                awful.screen.focus_relative(1)
                awesome.emit_signal("taglist::update")
            end,
            {description="next monitor",group="awesome"}),
            awful.key({modkey,"Shift"},"`", function ()
                client.focus:move_to_screen()
            end,
            {description="move client to next monitor",group="awesome"}),
    })
end)

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- ruled.client.append_rule {
    --     rule       = { class = "Firefox"     },
    --     properties = { screen = 1, tag = "2" }
    -- }
end)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 2, function()
            c:kill()
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    local titlebar = awful.titlebar(c, {size = 30})
    titlebar.widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            widget = wibox.container.margin,
            margins = 5,
            left = 20,
        },
        { -- Middle
            widget = wibox.container.margin,
            margins = 0,
            buttons = buttons,
        },
        { -- Right
            {
                {
                    awful.titlebar.widget.minimizebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.closebutton    (c),
                    layout = wibox.layout.fixed.horizontal(),
                    spacing = 5,
                },
                widget = wibox.container.margin,
                margins = 10,
            },
            widget = wibox.container.margin,
            margins = 0,
            right = 20,
        },
        layout = wibox.layout.align.horizontal,
        height = 20,
    }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Rounded windows
client.connect_signal("manage", function(c)
    if(not c.maximized and not c.fullscreen)then
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 30)
        end
    end
end)

-- Notifications
beautiful.notification_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 30)
end
naughty.connect_signal("request::display", function(n)
    naughty.layout.box{
        notification = n,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                widget = wibox.widget.textbox,
                                markup="<b>"..n.app_name.."</b>",
                            },
                            {
                                widget = wibox.widget.textbox,
                                text = " ",
                            },
                            {
                                widget = wibox.widget.textbox,
                                markup="<b>"..n.urgency.."</b>",
                            },
                            layout  = wibox.layout.align.horizontal,
                        },
                        {
                            {
                                id = "icon_role",
                                widget = wibox.widget.imagebox,
                                image = n.icon,
                                resize = true,
                                forced_width = 64,
                                forced_height = 64,
                                clip_shape = gears.shape.rounded_rect,
                            },
                            {
                                {
                                    widget = wibox.widget.textbox,
                                    markup="<b>"..n.title.."</b>",
                                },
                                naughty.widget.message,
                                spacing = 4,
                                layout  = wibox.layout.fixed.vertical,
                            },
                            fill_space = true,
                            spacing    = 4,
                            layout     = wibox.layout.fixed.horizontal,
                        },
                        {
                            widget = naughty.list.actions,
                            base_layout = wibox.widget {
                                spacing        = 3,
                                layout         = wibox.layout.flex.horizontal
                            },
                            forced_height = 40,
                            style = {
                                shape_normal = gears.shape.rounded_rect,
                                underline_normal = false,
                                shape_border_width_normal = 0,
                                bg_normal = beautiful.bg_focus,
                            },
                        },
                        spacing = 10,
                        layout  = wibox.layout.fixed.vertical,
                    },
                    margins = beautiful.notification_margin,
                    widget  = wibox.container.margin,
                },
                id     = "background_role",
                widget = naughty.container.background,
            },
            strategy = "min",
            width    = beautiful.notification_max_width,
            widget   = wibox.container.constraint,
        },
    }
end)

require("launcher")
