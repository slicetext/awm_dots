local home  = os.getenv('HOME') .. '/'
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
--outline,
--and sea
settings.theme="oxocarbon"

--The font of the setup
settings.font="sans 8"

--The wallpaper. uncomment the next line (remove the --) to set a custom wallpaper
--settings.wallpaper="~/.config/awesome/bg/oxocarbon.png"

--The profile picture on the lockscreen. Uncomment the next line to set a custom image. Note that you cannot use ~ to abbreviate the path to the icon.
--settings.user_icon=home..".config/awesome/icons/dark/max2.png"

--The defualt terminal to use
settings.terminal="alacritty"

--If your terminal is alacritty settings this to true will set your alacritty theme to the current theme of the desktop
settings.alacritty_theme_switcher=true

--Switch firefox themes based on your current theme
settings.firefox_theme_switcher=true

--Path to firefox profile (for the theme switcher)
settings.firefox_path="~/.mozilla/firefox/zc1miyqg.default-release/chrome"

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

--Icon theme
settings.icon_theme=home..".local/share/icons/Colloid"

--If the icons for kitty and alacritty should be replaced by a different icon
settings.replace_term_icons=true

--If the above is true, which icon should replace them?
settings.icon_term="qterminal"

--The city you live in (For weather purposes)
settings.city="denver"

--Your default browser
settings.browser="firefox"

--List of desktop icons
settings.desktop_icons={
	{
		"Firefox",
		"firefox",
		"firefox",
	},
	{
		"Chromium",
		"flatpak run io.github.ungoogled_software.ungoogled_chromium",
		"chromium-browser"
	},
	{
		"Alacritty",
		"alacritty",
		"alacritty",
	},
	{
		"Nemo",
		"nemo",
		"nemo",
	},
	{
		"Gapless",
		"flatpak run com.github.neithern.g4music",
		"com.github.neithern.g4music",
	},
}

--
settings.dock_pinned={
	{
		"firefox",
		"firefox",
	},
	{
		"alacritty",
		"alacritty",
	},
}

--Screen Width
settings.width=1920
--Screen Height
settings.height=1080

--Amount of gap
settings.gap=10

return settings
