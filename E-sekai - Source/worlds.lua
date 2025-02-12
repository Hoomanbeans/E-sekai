-- spike == spike objects
-- g_grass == normal walkable ground g_grass color
-- slime_g == slime size test
-- death_block == kill the player imidiatly no matter what state its in including cheats
-- health_up() == give 1hp to the player and only uses positions
local sti = require("sti")

local temp_boss_pos = 1 * 10 ^ 6

function world_load(world,tiled,win_size,slime,cannon,shield,sword,king)

    local platscalex = win_size.x
    local platscaley = win_size.y

    for i = 1, #tiled.layers["ground"].objects,1 do 
     world[i] = CreatePlatform(tiled.layers["ground"].objects[i].x - platscalex, tiled.layers["ground"].objects[i].y - platscaley, 
                                tiled.layers["ground"].objects[i].width, tiled.layers["ground"].objects[i].height, 
                                tiled.layers["ground"].objects[i].properties["ID"])
    end
    
    for i = 1, #tiled.layers["slime"].objects,1 do 
        slime[i] = CreateSlimes(tiled.layers["slime"].objects[i].x - platscalex, tiled.layers["slime"].objects[i].y - platscaley,  
                                love.math.random(200,550))
       end

    for i= 1, #tiled.layers["cannon"].objects,1  do
    
       local C_x 
       local C_y
       local anim_frame

       -- if you get and error saying "Error vector2.lua:33: attempt to perform arithmetic on field 'x' (a nil value) "
       -- you missd and id in one of the cannons

        if tiled.layers["cannon"].objects[i].properties["ID"] == "left" then
            C_x = -1
            C_y = 0
            anim_frame = 5
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "right" then
            C_x = 1
            C_y = 0
            anim_frame = 1
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "up" then
            C_x = 0
            C_y = -1
            anim_frame = 6
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "down" then
            C_x = 0
            C_y = 1
            anim_frame = 3
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "d_left" then
            C_x = -1
            C_y = 1
            anim_frame = 4
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "d_right" then
            C_x = 1
            C_y = 1
            anim_frame = 8
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "u_left" then
            C_x = -1
            C_y = -1
            anim_frame = 7
        elseif tiled.layers["cannon"].objects[i].properties["ID"] == "u_right" then
            C_x = 1
            C_y = -1
            anim_frame = 2
        end    

        cannon[i] = CreateCannon(tiled.layers["cannon"].objects[i].x - platscalex, tiled.layers["cannon"].objects[i].y - platscaley, C_x, C_y,anim_frame)

    end

    
    for i = 1, #tiled.layers["shield"].objects , 1 do
    
        shield[i] = CreateShield(tiled.layers["shield"].objects[i].x - platscalex, tiled.layers["shield"].objects[i].y - platscaley)

    end

    
    for i = 1 , #tiled.layers["sword"].objects , 1 do
        local velo_x
        local velo_y 
        local tempo 
        local w
        local h
        if tiled.layers["sword"].objects[i].properties["ID"] == "v_slow" then
            velo_y = 0
            velo_x = 0
            tempo = {6}
            h = 110
            w = 50
        elseif tiled.layers["sword"].objects[i].properties["ID"] == "v_medio" then

            velo_y = 0
            velo_x = 0
            tempo = {4.5}
            h = 50
            w = 110
            
        elseif tiled.layers["sword"].objects[i].properties["ID"] == "v_fast" then
            
            velo_y = 100
            velo_x = 0
            tempo = {2.5}
            h = 110
            w = 50

        elseif tiled.layers["sword"].objects[i].properties["ID"] == "h_slow" then
            velo_y = 0
            velo_x = -50
            tempo = 4.5
            h = 110
            w = 50
        elseif tiled.layers["sword"].objects[i].properties["ID"] == "h_medio" then
            velo_y = 0
            velo_x = -100
            tempo = {4.5}
            h = 110
            w = 50
        elseif tiled.layers["sword"].objects[i].properties["ID"] == "h_fast" then
            velo_y = 0
            velo_x = -150
            tempo = {4.5}
            h = 110
            w = 50
        end    

        sword[i] =  CreatSwords(tiled.layers["sword"].objects[i].x - platscalex, 
                                    tiled.layers["sword"].objects[i].y - platscaley,
                                    w,h,
                                    velo_x,velo_y,tempo)
    end
  

   


end

function What_level(inc_level)

    local world
    local sound = Get_sound()

    if inc_level == 1 then
        world = sti("Assets/leves/teste/level1_forest_32x32_2.lua")
        Play_audio(sound,"BGM_forest",50,100,false)
    elseif inc_level == 2 then
        world = sti("Assets/leves/level_2/level2_cave.lua")
        Play_audio(sound,"BGM_cave",50,100,false)
    elseif inc_level == 3 then
        world = sti("Assets/leves/boss/boss.lua")
        Play_audio(sound,"BGM_boss",50,100,false)
    end    

    return world

end


