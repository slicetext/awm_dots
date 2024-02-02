local render=require("render")

local screen_width=500
local screen_height=200
win=render.spawn_win(screen_width,screen_height)

cross_product=function(one,two)
	return {
		(one[2]*two[3]-one[3]*two[2]),
		(one[3]*two[1]-one[1]*two[3]),
		(one[1]*two[2]-one[2]*two[1]),
	}
end

local map={
	{" "," "," ","x",},
	{"x","x"," ","x",},
	{" "," "," "," ",},
}

local player_coords={2,1,1}
local player_rotation={0,1}
local raycast=function(p_c,p_r)
	while(map[1][p_c[1]]~=nil and map[p_c[2]]~=nil)do
		if(map[p_c[2]][p_c[1]]~=" ")then
			return true
		end
		p_c[1]=p_c[1]+p_r[1]
		p_c[2]=p_c[2]+p_r[2]
	end
	return false
end
local render=function()
	local dir=-1
	for i=player_coords[1]-1,player_coords[1]+1,1 do
		if(raycast(player_coords,{player_rotation[1]+dir,player_rotation[2]}))then
			naughty.notify({title="rendering"})
			render.draw_rect(win,{(i*screen_width/4)-screen_width/6,1},{screen_width/3,screen_height},beautiful.bg_urgent)
		end
		dir=dir+1
end
end
render()
