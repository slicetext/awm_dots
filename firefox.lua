user=require("settings")
awful=require("awful")
naughty=require("naughty")
local firefox_theme_list={"biscuit","outline","oxocarbon","swamp","rose_pine","solarized","fullerene","tokyo_night","hacker","camellia","nordic"}
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

if(user.firefox_theme_switcher and has_value(firefox_theme_list,user.theme))then
	local file=user.theme
	awful.spawn.with_shell("rm "..user.firefox_path.."/userChrome.css")
	awful.spawn.with_shell("cp -r ~/.config/awesome/firefox_themes/"..file..".css "..user.firefox_path.."/userChrome.css")
end
