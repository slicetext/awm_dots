settings={}
--The theme is the colorscheme of the setup. Possible options include:
--gruvbox, 
--gruvbox_light, 
--tokyo_night, 
--light, 
--biscuit, 
--swamp, 
--rose_pine, 
--oxocarbon, 
--nordic,
--hacker,
--paper,
--camellia,
--fullerene,
--solarized,
--and sea
settings.theme="rose_pine"

--The font of the setup
settings.font="sans 8"

--The wallpaper. uncomment the next line (remove the --) to set a custom wallpaper
--settings.wallpaper="~/.config/awesome/bg/oxocarbon.png"

--The profile picture on the lockscreen. Uncomment the next line to set a custom image. Note that you cannot use ~ to abbreviate the path to the icon.
--settings.user_icon="~/.config/awesome/icons/max.png"

--The defualt terminal to use
settings.terminal="alacritty"

--If your terminal is alacritty settings this to true will set your alacritty theme to the current theme of the desktop
settings.alacritty_theme_switcher=true

--Use animations (recommended)
settings.animations=true

--Command used to take a screenshot
settings.screenshot="kazam -f"

--Defualt Text Editor
settings.editor="gedit"

--Use the built-in run prompt when Super+D is pressed
settings.run=true

--If the previous setting is false, what command should be run?
settings.launcher=""

--Use Picom Compositor
settings.picom=true

--Use the music player
settings.music=true

--Have a root menu (Right click menu on the desktop)
settings.root_menu=true

--Password for lockscreen. If this is blank, the screen won't lock. Lock the screen with Super+Escape
settings.password="test"

return settings
