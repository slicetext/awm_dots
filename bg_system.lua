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
local charge_notif=false
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
		awful.spawn.easy_async_with_shell("acpi -b | grep Discharging",function(out)
			if(out=="" and charge_notif==false)then
				charge_notif=true
				naughty.notify({title="System",text="Device is Charging.",icon=beautiful.gear_icon})
			elseif(out~="")then
				charge_notif=false
			end
		end)
	end
}
