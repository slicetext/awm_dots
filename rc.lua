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
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- add stuff
-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")
--local cr= require("cairo")
local menubar_utils = require "menubar.utils"
local rubato=require "lib.rubato"
local user=require "settings"
local get_icon=require("lib.util.get_icon")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "You're stupid! Don't break the config!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
 in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = user.terminal
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

function wait(time)
if tonumber(time) ~= nil then
os.execute("sleep "..tonumber(time))
else
os.execute("sleep "..tonumber("0.1"))
end
end

if(user.picom==true)then
	awful.spawn.with_shell("killall picom")
	wait()
	awful.spawn.with_shell("picom")
end

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
}
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

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end




mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
naughty.config.defaults.position = "bottom_right"
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget{
	format="%I\n%M",
	orientation="vertical",
	widget=wibox.widget.textclock,
	align="center",
}
mytextclockOp="ff"
mytextclock:connect_signal("mouse::enter",function()
    mytextclockOp="aa"
    mytextclock.bg=beautiful.bg_focus..mytextclockOp
end)
mytextclock:connect_signal("mouse::leave",function()
    mytextclockOp="ff"
    mytextclock.bg=beautiful.bg_focus..mytextclockOp
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function(c)
                                            		c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
												  awesome.emit_signal("win_rc::toggle",{c})
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

  --helpers.hoverCursor(systray_btn)
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s)
    end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local trayT = wibox.widget{
	text="󰅃",
	align="center",
	widget=wibox.widget.textbox,
}
trayT:connect_signal("button::press",function()
	awesome.emit_signal("tray::toggle")
end)

local musicT = wibox.widget{
	text=" 󰎌 ",
	widget=wibox.widget.textbox,
}
local launcherb = wibox.widget{
	{
	--image="~/.config/awesome/icons/awm.png",
	--resize=true,
	text="󰑮",
	font="sans 14",
	align="center",
	widget=wibox.widget.textbox,
	},
	bg=beautiful.bg_focus,
    shape=function(cr, width, height)
        return gears.shape.rounded_rect(cr, width, height, 5)
    end,
	widget=wibox.container.background,
}
launcherbOp="ff"
launcherb:connect_signal("mouse::enter",function()
    launcherbOp="aa"
    launcherb.bg=beautiful.bg_focus..launcherbOp
end)
launcherb:connect_signal("mouse::leave",function()
    launcherbOp="ff"
    launcherb.bg=beautiful.bg_focus..launcherbOp
end)
musicT:connect_signal("button::press", function()
	awesome.emit_signal("music::toggle")
end)
mytextclock:connect_signal("button::press", function()
	awesome.emit_signal("dash::toggle")
end)
launcherb:connect_signal("button::press",function()
	awesome.emit_signal("drawer::toggle")
end)
layoutb=wibox.widget{
	text="󰋁",
	font="sans 16",
	align="center",
	widget=wibox.widget.textbox,
}
layoutb:connect_signal("button::press",function()
	awesome.emit_signal("layout::toggle")
end)
batterybar=wibox.widget{
    widget=wibox.widget.progressbar,
    shape=gears.shape.rounded_rect,
    max_value=100,
    value=50,
    color=beautiful.border_focus,
    background_color=beautiful.bg_focus,
}
battery=wibox.widget{
    batterybar,
    forced_width=60,
    forced_height=25,
    layout=wibox.container.rotate,
    direction="east",
}
systray = wibox.widget({
    visible=false,
    orientation="vertical",
    horizontal=false,
    widget=wibox.widget.systray,
})
awesome.connect_signal("tray::toggle",function()
    systray.visible=not systray.visible
    systray.screen=awful.screen.focused()
    if(systray.visible==true)then
        trayT.text="󰅀"
    else
        trayT.text="󰅃"
    end
end)
awful.screen.connect_for_each_screen(function(s)
	client.connect_signal("manage", function(c)
    	c.shape = function(cr, w, h)
        	gears.shape.rounded_rect(cr, w, h, 10)
    	end
	end)
    -- Wallpaper
    set_wallpaper(beautiful.wallpaper)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
	--systray
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
		background=beautiful.bg_minimize,
        buttons = taglist_buttons,
		orientation="vertical",
		layout={
			layout=wibox.layout.fixed.vertical,
		},
		widget_template={
			widget=wibox.container.margin,
			margins=5,
			{
				widget=wibox.container.background,
                shape=function(cr, width, height)
                    return gears.shape.rounded_rect(cr, width, height, 2)
                end,
				forced_width=1,
				forced_height=50,
				bg=beautiful.bg_normal,
                border_width=1,
                border_color=beautiful.bg_normal,
				id="bg",
			},
			create_callback=function(self,tag)
				self.animate = rubato.timed {
                    duration = 0.15,
                    subscribed = function (h)
                        self:get_children_by_id('bg')[1].forced_height = h
                    end
                }
				self.update=function()
					if(tag.selected)then
                        if(awful.screen.focused()==s)then
                            self:get_children_by_id('bg')[1].bg=beautiful.bg_urgent
                        end
						self:get_children_by_id('bg')[1].border_color=beautiful.bg_urgent
						self.animate.target=50
					elseif(#tag:clients()>0)then
						self:get_children_by_id('bg')[1].bg=beautiful.bg_focus
						self:get_children_by_id('bg')[1].border_color=beautiful.bg_focus
						self.animate.target=40
					else
						self:get_children_by_id('bg')[1].bg=beautiful.bg_normal
						self:get_children_by_id('bg')[1].border_color=beautiful.bg_normal
						self.animate.target=30
					end
					for client in pairs(tag:clients())do
					end
				end
                self:connect_signal("taglist::update",function()
                    self.update()
                end)
				self.update()
			end,
			update_callback=function(self)
				self.update()
			end,
		}
    }

    -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist {
        --screen  = s,
        --filter  = awful.widget.tasklist.filter.currenttags,
        --buttons = tasklist_buttons
    
    --}
	s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    layout   = {
        spacing_widget = {
            {
                forced_width  = 100,
                forced_height = 24,
                thickness     = 100,
                color         = "#77777700",
                widget        = wibox.widget.separator
            },
            valign = "center",
            halign = "center",
            widget = wibox.container.place,
        },
        spacing = 5,
        layout  = wibox.layout.fixed.vertical
    },
	        widget_template = {
            {
                {
                    id     = "clienticon",
					--widget = awful.widget.clienticon,
					image="",
					widget=wibox.widget.imagebox,
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
        id              = 'background_role',
        --forced_width    = 30,
        --forced_height   = 64,
        widget          = wibox.container.background,
        create_callback = function(self, c, index, objects) --luacheck: no unused
			if(c.class~="Alacritty"and c.class~="kitty"and user.replace_term_icons==true)then
            	self:get_children_by_id('clienticon')[1].image = get_icon(nil,c.class,c.class,false)
			else
            	self:get_children_by_id('clienticon')[1].image = get_icon(nil,user.icon_term,user.icon_term,false)
			end
			--self:get_children_by_id('icon')[1].image=get_icon(nil,c.class,c.class,false)
        end,
    },

}

	s.battery = wibox.widget {
    {
        max_value     = 1,
        value         = 0.5,
        forced_height = 20,
        forced_width  = 100,
        paddings      = 1,
        border_width  = 1,
        border_color  = beautiful.border_color,
        widget        = wibox.widget.progressbar,
    },
    {
        text   = "50%",
        valign = "center",
        halign = "center",
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.stack
}
spacer = wibox.widget {
    widget = wibox.widget.separator,
    orientation="vertical",
    thickness=1

}
-- Create the wibox
s.mywibox = awful.wibar({ position = "left", screen = s , width=30,border_color=beautiful.border_control,border_width=beautiful.bar_border})

-- Add widgets to the wibox
s.mywibox:setup {
    layout = wibox.layout.align.vertical,
    expand="none",
    {
        margins=5,
        widget=wibox.container.margin,
        { -- Left widgets
            layout = wibox.layout.fixed.vertical,
            --mylauncher,
            launcherb,
            spacing=5,
            {
                {
                    s.mytaglist,
                    layout=wibox.layout.align.vertical,
                },
                widget=wibox.container.background,
                shape=function(cr, width, height)
                    return gears.shape.rounded_rect(cr, width, height, 5)
                end,
                bg=beautiful.bg_minimize,
            },
            s.mypromptbox,
        },
    },
    {layout=wibox.layout.align.vertical},
    {
        margins=5,
        widget=wibox.container.margin,
        {  --Right widgets
            layout = wibox.layout.fixed.vertical,
            --mykeyboardlayout,
            --battery,
            trayT,
            systray,
            {
                {
                    {
                        mytextclock,
                        layout=wibox.layout.align.vertical,
                    },
                    widget=wibox.container.margin,
                    margins={left=1,right=1,top=10,bottom=10,},
                },
                widget=wibox.container.background,
                shape=function(cr, width, height)
                    return gears.shape.rounded_rect(cr, width, height, 5)
                end,
                bg=beautiful.bg_minimize,
            },
            {text=" ",widget=wibox.widget.textbox,},
            layoutb,
        },
    }
}
end)
-- }}}
monitor_old=tonumber(0)
gears.timer{
    autostart=false,
    timeout=10,
    callback=function()
        awful.spawn.easy_async_with_shell("xrandr -q | grep ' connected' | wc -l;",function(out)
            local outnum=tonumber(out)
            if(outnum~=monitor_old)then
                if(outnum==1)then
                    awful.spawn.easy_async_with_shell("xrandr --output eDP-1 --mode 1366x768 --pos 2142x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-1-5 --off --output DP-1-6 --off")
                else
                    awful.spawn.easy_async_with_shell("xrandr --output eDP-1 --mode 1366x768 --pos 2142x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-1-5 --off --output DP-1-6 --primary --mode 1920x1080 --pos 0x0 --rotate normal")
                end
                --awesome.restart()
                naughty.notify{text="old "..monitor_old.." new "..outnum}
                monitor_old=outnum
            end
        end)
    end
}
-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () awesome.emit_signal("rclick::toggle")end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
        end,
        {description = "focus right", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
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

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "d",     function () 
		if(user.run==true)then
			awesome.emit_signal("launch::toggle") 
		else
			awful.spawn(user.launcher)
		end
	end,
              {description = "run prompt", group = "launcher"}),

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
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey,           }, "/",
        function ()
			awesome.emit_signal("binds::toggle")
        end,
        {description = "toggle keybinds popup",group="help"}),
	awful.key({}, "XF86AudioRaiseVolume", function ()
		awesome.emit_signal("volume::up")
	end,
	{description="increase Volume",group="awesome"}),
	awful.key({}, "XF86AudioLowerVolume", function ()
		awesome.emit_signal("volume::down")
	end,
	{description="decrease Volume",group="awesome"}),
	awful.key({}, "XF86AudioMute", function ()
		awesome.emit_signal("volume::mute")
	end,
	{description="mute Volume",group="awesome"}),
	awful.key({}, "XF86MonBrightnessUp", function ()
		awesome.emit_signal("bright::up")
	end,
	{description="increase brightness",group="awesome"}),
	awful.key({}, "XF86MonBrightnessDown", function ()
		awesome.emit_signal("bright::down")
	end,
	{description="decrease brightness",group="awesome"}),
	awful.key({modkey,}, "m", function ()
		awesome.emit_signal("dash::toggle")
	end,
	{description="toggle dash",group="awesome"}),
	awful.key({modkey,}, "t", function ()
		awesome.emit_signal("tools::toggle")
	end,
	{description="toggle tools",group="awesome"}),
	awful.key({modkey,}, "c", function ()
		awesome.emit_signal("copy::toggle")
	end,
	{description="toggle copy",group="awesome"}),
	awful.key({modkey,"Shift"}, "l", function ()
		awful.layout.set(awful.layout.suit.fair)
	end,
	{description="set layout to fairv layout",group="awesome"}),
	awful.key({modkey,"Mod1"}, "l", function ()
		awful.layout.set(awful.layout.suit.tile)
	end,
	{description="set layout to tile layout",group="awesome"}),
	awful.key({modkey,"Shift","Mod1"}, "l", function ()
		awful.layout.set(awful.layout.suit.floating)
	end,
	{description="set layout to floating layout",group="awesome"}),
	awful.key({modkey,}, "Escape", function ()
		awesome.emit_signal("lock::toggle")
	end,
	{description="set layout to floating layout",group="awesome"}),
	awful.key({"Mod4"}, "Right", function ()
		awesome.emit_signal("game::right")
	end,
	{description="move game character right",group="awesome"}),
	awful.key({"Mod4"}, "Left", function ()
		awesome.emit_signal("game::left")
	end,
	{description="move game character left",group="awesome"}),
	awful.key({"Mod4"}, "Up", function ()
		awesome.emit_signal("game::up")
	end,
	{description="move game character up",group="awesome"}),
	awful.key({"Mod4"}, "Down", function ()
		awesome.emit_signal("game::down")
	end,
	{description="move game character down",group="awesome"}),
	awful.key({"Mod4","Mod1"}, "Right", function ()
		awesome.emit_signal("game::s_right")
	end,
	{description="move game character right",group="awesome"}),
	awful.key({"Mod4","Mod1"}, "Left", function ()
		awesome.emit_signal("game::s_left")
	end,
	{description="move game character left",group="awesome"}),
	awful.key({"Mod4","Mod1"}, "Up", function ()
		awesome.emit_signal("game::s_up")
	end,
	{description="move game character up",group="awesome"}),
	awful.key({"Mod4","Mod1"}, "Down", function ()
		awesome.emit_signal("game::s_down")
	end,
	{description="move game character down",group="awesome"}),
	awful.key({"Mod4"}, "g", function ()
		awesome.emit_signal("game::toggle")
	end,
	{description="toggle game",group="awesome"}),
	awful.key({"Mod4"}, "n", function ()
		awesome.emit_signal("notif::toggle")
	end,
	{description="open notif center",group="awesome"}),
	awful.key({"Mod4"}, "a", function ()
		awesome.emit_signal("drawer::toggle")
	end,
	{description="toggle app drawer",group="awesome"}),
	awful.key({"Mod4","Shift"},"g", function ()
		awesome.emit_signal("pong::toggle")
	end,
	{description="toggle pong",group="awesome"}),
	awful.key({modkey},"q", function ()
		awesome.emit_signal("overview::toggle")
	end,
	{description="toggle overview",group="awesome"}),
	awful.key({modkey},"`", function ()
        awesome.emit_signal("taglist::update")
		awful.screen.focus_relative(1)
        awesome.emit_signal("taglist::update")
	end,
	{description="next monitor",group="awesome"}),
	awful.key({modkey,"Shift"},"`", function ()
        client.focus:move_to_screen()
	end,
	{description="move client to next monitor",group="awesome"})
)

clientkeys = gears.table.join(
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
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.centered,
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            --awful.mouse.client.resize(c)
			awesome.emit_signal("win_rc::toggle",{c})
        end),
        awful.button({ }, 2, function()
            c:kill()
        end)
    )

    awful.titlebar(c,{position="left",size=25}) : setup {
		widget=wibox.container.margin,
		margins=2,
		{
        { -- Left
			--awful.titlebar.widget.iconwidget(c),
			{
				image=get_icon(nil,c.class,c.class,false),
				widget=wibox.widget.imagebox,
			},
            buttons = buttons,
            layout  = wibox.layout.fixed.vertical,
			widget=wibox.container.margin,
			margins=2
        },
        { -- Middle
            { -- Title
                align  = "center",
                --widget = awful.titlebar.widget.titlewidget(c)
				widget=wibox.widget.textbox,
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
			{
				awful.titlebar.widget.minimizebutton(c),
            	awful.titlebar.widget.maximizedbutton(c),
            	awful.titlebar.widget.closebutton    (c),
				spacing=5,
            	layout = wibox.layout.fixed.vertical(),
			},
			widget=wibox.container.margin,
			margins=2,
        },
        layout = wibox.layout.align.vertical,
    }
	}
end)
beautiful.useless_gap = user.gap
beautiful.gap_single_client = true
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
gears.timer{
    timeout=1,
    autostart=true,
    callback=function()
        awful.spawn.easy_async_with_shell("cat /proc/acpi/button/lid/LID0/state",function(out)
            if(out:find("closed"))then
                awful.spawn.easy_async_with_shell("xset dpms force off")
            else
                awful.spawn.easy_async_with_shell("xset dpms force on")
            end
        end)
    end,
}
gears.timer{
	timeout=1,
	autostart=true,
	callback=function()
        awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/capacity",function(out)
            batterybar.value=tonumber(string.gsub(out,"\n",""))
        end)
    end,
}
-- }}}
if(user.music==true)then
	require("music")
end


require("dash")
require("binds")
require("tools")
require("audio")
require("launcher")
require("powermenu")
if(user.root_menu)then
	require("rclick")
end
require("alacritty")
require("firefox")
require("lock")
require("layout")
require("notif")
require("win_rclick")
require("weather")
require("game")
require("notif_center")
require("app_drawer")
require("pong")
require("desktop_icons")
require("dock")
require("term")
require("bg_system")
require("overview")
--require("camera")
require("onscreenkeyboard")
