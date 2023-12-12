user=require("settings")
awful=require("awful")
naughty=require("naughty")
local alacritty_theme_list={"biscuit","hacker","oxocarbon","swamp","nordic","tokyo_night","rose_pine","camellia","solarized","gruvbox","gruvbox_light","paper","fullerene"}
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
	awful.spawn.with_shell("rm ~/.config/alacritty/alacritty.yml")
	awful.spawn.with_shell("cp -r ~/.config/awesome/alacritty_themes/"..file..".yml ~/.config/alacritty/alacritty.yml")
else
	awful.spawn.with_shell("rm ~/.config/alacritty/alacritty.yml")
	awful.spawn.with_shell("cp -r ~/.config/awesome/alacritty_themes/oxocarbon.yml ~/.config/alacritty/alacritty.yml")
end
