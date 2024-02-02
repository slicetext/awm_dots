---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local icon_path = gfs.get_configuration_dir().."icons/"


local gears = require("gears")

local user = require("settings")

local naughty = require("naughty")

local color_scheme = settings.theme or "oxocarbon"
local file=require("themes."..color_scheme)

local theme = {}

theme.font          = user.font

theme.bg_normal     = file.bg_normal
theme.bg_focus      = file.bg_focus
theme.bg_urgent     = file.bg_urgent
theme.bg_minimize   = file.bg_minimize
theme.bg_systray    = file.bg_normal

theme.fg_normal     = file.fg_normal
theme.fg_focus      = file.fg_focus
theme.fg_urgent     = file.fg_urgent
theme.fg_minimize   = file.fg_minimize
theme.button_outline= file.button_outline or 0
theme.bar_border    = file.bar_border or 0

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = file.border_normal
theme.border_focus  = file.border_focus
theme.border_marked = file.border_marked
theme.border_control= file.border_control or file.border_focus
theme.tasklist_disable_task_name = true
theme.tasklist_align = "center"
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
--theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(200)
theme.menu_border_width = dpi(1)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_focus  = gears.color.recolor_image(icon_path.."dark/close2.png",theme.fg_normal)
theme.titlebar_minimize_button_focus  = gears.color.recolor_image(icon_path.."dark/min.png",theme.fg_normal)
theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(icon_path.."dark/max2.png",theme.fg_normal)
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(icon_path.."dark/max2.png",theme.fg_normal)
theme.titlebar_maximized_button_normal_active = gears.color.recolor_image(icon_path.."dark/minimize.png",theme.fg_normal)
theme.titlebar_maximized_button_focus_active  = gears.color.recolor_image(icon_path.."dark/minimize.png",theme.fg_normal)

theme.wallpaper = user.wallpaper or file.wallpaper or "~/.config/awesome/bg/oxocarbon.png"

-- You can use your own layout icons like this:
theme.layout_fairh = gears.color.recolor_image(themes_path.."default/layouts/fairhw.png",theme.fg_normal)
theme.layout_fairv = gears.color.recolor_image(themes_path.."default/layouts/fairvw.png",theme.fg_normal)
theme.layout_floating  = gears.color.recolor_image(themes_path.."default/layouts/floatingw.png",theme.fg_normal)
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = gears.color.recolor_image(themes_path.."default/layouts/tilew.png",theme.fg_normal)
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = gears.color.recolor_image(themes_path.."default/layouts/spiralw.png",theme.fg_normal)
theme.layout_dwindle = gears.color.recolor_image(themes_path.."default/layouts/dwindlew.png",theme.fg_normal)
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "colloid-dark"


--theme.notification_width=dpi(150)
--theme.notification_height=dpi(75)
--theme.notification_shape=gears.shape.rounded_rect



return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
