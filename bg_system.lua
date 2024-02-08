local naughty=require("naughty")
local awful=require("awful")
local gears=require("gears")
local beautiful=require("beautiful")

local done=false
local caps_status="off\n"
local update=gears.timer{
	timout=30,
	autostart=true,
	callback=function()
		awful.spawn.easy_async_with_shell("xset -q | sed -n 's/^.*Caps Lock:\\s*\\(\\S*\\).*$/\\1/p'",function(out)
			if(out~=caps_status)then
				naughty.notify({title="System",text="Caps lock is "..out,icon=beautiful.gear_icon})
				caps_status=out
			end
		end)
	end
}
local update2=gears.timer{
	timout=3000,
	autostart=true,
	callback=function()
		awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/capacity",function(out)
			if(tonumber(out)<=10 and done==false)then
				naughty.notify({title="System",text="Warning: Low Battery. Battery is at "..out.." percent.",icon=beautiful.gear_icon})
				done=true
			elseif(tonumber(out)>10)then
				done=false
			end
		end)
	end
}
