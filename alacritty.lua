user=require("settings")
awful=require("awful")
naughty=require("naughty")
local alacritty_theme_list={"biscuit","hacker","oxocarbon","swamp","nordic","tokyo_night","rose_pine","camellia","solarized","gruvbox","gruvbox_light","paper","fullerene","outline"}
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

if(user.terminal=="alacritty"and user.alacritty_theme_switcher and has_value(alacritty_theme_list,user.theme))then
	local file=user.theme
	awful.spawn.with_shell("rm ~/.config/alacritty/alacritty.toml")
	awful.spawn.with_shell("cp -r ~/.config/awesome/alacritty_themes/"..file..".toml ~/.config/alacritty/alacritty.toml")
else
	awful.spawn.with_shell("rm ~/.config/alacritty/alacritty.toml")
	awful.spawn.with_shell("cp -r ~/.config/awesome/alacritty_themes/oxocarbon.toml ~/.config/alacritty/alacritty.toml")
end
