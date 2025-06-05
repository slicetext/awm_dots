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

local modifier_table={
    Shift_L=false
}
local generate_key=function(args)
    args.toggle=args.toggle or false
    args.width=args.width or 1
    local temp=wibox.widget{
        widget=wibox.container.background,
        layout=wibox.layout.vertical,
        bg=beautiful.bg_focus,
        forced_width=awful.screen.focused().geometry.width/20*args.width,
        forced_height=awful.screen.focused().geometry.height/15,
        expand=false,
        shape=gears.shape.rounded_rect,
        buttons={
            awful.button({},1,function()
                local key=args.key or args.symbol
                if(not args.toggle)then
                    root.fake_input("key_press",key)
                    root.fake_input("key_release",key)
                else
                    if(modifier_table[key]~=nil)then
                        if(modifier_table[key]==true)then
                            root.fake_input("key_press",key)
                            root.fake_input("key_release",key)
                            naughty.notify({text=tostring(modifier_table[key])})
                        else
                            root.fake_input("key_press",key)
                        end
                        modifier_table[key]=not modifier_table[key]
                    end
                end
            end),
        },
        {
            layout=wibox.layout.vertical,
            widget=wibox.container.background,
            margin=2,
            {
                widget=wibox.widget.textbox,
                text=args.symbol,
                align="center",
            }
        }
    }
    temp:connect_signal("mouse::enter",function()
        temp.bg=beautiful.bg_minimize
    end)
    temp:connect_signal("mouse::leave",function()
        temp.bg=beautiful.bg_focus
    end)
    return temp
end
local top_row=wibox.widget{
    widget=wibox.container.margin,
    margin=4,
    layout=wibox.layout.grid,
    row_count=1,
    column_count=12,
    orientation="horizontal",
    spacing=10,
    align="center",
    generate_key({symbol="~"}),
    generate_key({symbol="1"}),
    generate_key({symbol="2"}),
    generate_key({symbol="3"}),
    generate_key({symbol="4"}),
    generate_key({symbol="5"}),
    generate_key({symbol="6"}),
    generate_key({symbol="7"}),
    generate_key({symbol="7"}),
    generate_key({symbol="8"}),
    generate_key({symbol="9"}),
    generate_key({symbol="0"}),
    placement=awful.placement.centered,
}
local second_row=wibox.widget{
    widget=wibox.container.margin,
    margin=4,
    layout=wibox.layout.grid,
    row_count=1,
    column_count=12,
    orientation="horizontal",
    spacing=10,
    align="center",
    generate_key({symbol="q"}),
    generate_key({symbol="w"}),
    generate_key({symbol="e"}),
    generate_key({symbol="r"}),
    generate_key({symbol="t"}),
    generate_key({symbol="y"}),
    generate_key({symbol="u"}),
    generate_key({symbol="i"}),
    generate_key({symbol="o"}),
    generate_key({symbol="p"}),
    placement=awful.placement.centered,
}
local third_row=wibox.widget{
    widget=wibox.container.margin,
    margin=4,
    layout=wibox.layout.grid,
    row_count=1,
    column_count=12,
    orientation="horizontal",
    spacing=10,
    align="center",
    generate_key({symbol="a"}),
    generate_key({symbol="s"}),
    generate_key({symbol="d"}),
    generate_key({symbol="f"}),
    generate_key({symbol="g"}),
    generate_key({symbol="h"}),
    generate_key({symbol="j"}),
    generate_key({symbol="k"}),
    generate_key({symbol="l"}),
    generate_key({symbol=";"}),
    placement=awful.placement.centered,
}
local fourth_row=wibox.widget{
    widget=wibox.container.margin,
    margin=4,
    layout=wibox.layout.grid,
    row_count=1,
    column_count=12,
    orientation="horizontal",
    spacing=10,
    align="center",
    --generate_key({symbol="Shift",key="Caps_Lock",width=1,}),
    generate_key({symbol="Shift",key="Shift_L",width=1,toggle=true}),
    generate_key({symbol="z"}),
    generate_key({symbol="x"}),
    generate_key({symbol="c"}),
    generate_key({symbol="v"}),
    generate_key({symbol="b"}),
    generate_key({symbol="n"}),
    generate_key({symbol="m"}),
    generate_key({symbol=","}),
    generate_key({symbol="."}),
    generate_key({symbol="/"}),
    placement=awful.placement.centered,
}


local keyboard=awful.popup({
    ontop=true,
    visible=false,
    screen=awful.screen.focused(),
    x=awful.screen.focused().geometry.x+30,
    y=awful.screen.focused().geometry.y+awful.screen.focused().geometry.height/8*5,
    layout=wibox.layout.vertical,
    widget={
        forced_width=awful.screen.focused().geometry.width,
        forced_height=awful.screen.focused().geometry.height/8*3,
        bg=awful.bg_normal,
        widget=wibox.container.background,
        layout=wibox.layout.vertical,
        {
            top_row,
            second_row,
            third_row,
            fourth_row,
            layout=wibox.layout.grid,
            orientation="vertical",
            widget=wibox.container.margin,
            forced_width=100,
            spacing=10,
        },
    }
})
naughty.notify({text="?"})
