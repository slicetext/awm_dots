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
settings.theme="oxocarbon"

--The font of the setup
settings.font="sans 8"

--The wallpaper. uncomment the next line (remove the --) to set a custom wallpaper
--settings.wallpaper="~/.config/awesome/bg/oxocarbon.png"

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

return settings
