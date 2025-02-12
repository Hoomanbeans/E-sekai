require "vector2"
require "collision"

--no tiled version
require "platform"
require "player"
require "slime"
require "cannon"
require "worlds"
require "boss"
require "king"
require "shield"
--no tiled version
require "health"
require "camera"

--tiled version
local sti = require("sti")
--tiled version

require "menu"
require "sound_manager"
require "Animations"
require "debug_info"

require "conf"

local world = {}
local slime = {}
local gravity = vector2.new(0, 100)
local cannon = {}

local player = {}
local king = {}
local sword = {}

local shield = {}

local start_point = vector2.new(-180, 450)
local camera = {}

--version 2
local world_v2
local sound = {}
local windows_size = vector2.new(380,320)
local inc_level = 1
-- version 2

--menu variables
local start_menu = false
local pause_menu = false
local menu_cd = 0.5
--menu variables

function love.load()
    love.window.setTitle("E-sekai") -- windows title
    love.graphics.setBackgroundColor(0.156, 0.886, 0.964) -- background

    Start = returnStart() -- menu
    pause = returnPause() -- menu 

    world_v2 = What_level(inc_level)
    world_load(world,world_v2,windows_size,slime,cannon,shield,sword,king) -- writes the world
    camera = Get_cam()
    sound = Get_sound()

    king = getking()
    player = getplayer()
    Player_start_pos(player,start_point)
    Load_ssheet(player,slime,cannon,king,shield) --this was to be last to load
    LoadMenu(player)

end

function love.update(dt)
    if dt > 0.1 then --fixes game crash due to skiping unrestired frames
        return
    end
    Start = returnStart() -- menu
    pause = returnPause() -- menu
    updateMenu(dt)        -- menu
    if Start == true then --menu
        if pause == false then --menu

            UpdatePlayer(dt, gravity, world, cannon, king,shield,sound , inc_level)
            UpdateSlime(dt, gravity, world, slime, player)
            UpdateCannon(dt, world, cannon)--canhao
            UpdateSwords(dt, sword, world, gravity, player, king)
            UpdateShield(dt,shield,gravity,world,player)
            CheckHealth(player.hp, player, start_point)
            --debug menu
            Status_modes(player, start_point)
            --debug menu
            --updateMenu(player)

    world_v2:update(dt)
    camera.posx = player.position.x - (love.graphics.getWidth()/2)
    camera.posy = player.position.y - (love.graphics.getHeight()/2)
    --end
    --io.write(inc_level)
        end
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)

    Cam_set(camera,world_v2,player) --world has to be drawn here otherwise it just completely breaks the game

    local playerpos = GetPlayerPosition()
    if Start == false then
        DrawMenu()
    else

    DrawPlayer()
    DrawProjectiles(player.projectiles)
    DrawPlatforms(world)
    DrawSlime(slime)
    DrawCannon(cannon)--canhao
    DrawShield(shield)
    Drawking(king)
    DrawSwords(sword, king)
    Createlife(player.hp, camera)

    --debug menu
    --Show_menu()
    --debug 

        if pause == true then
            love.graphics.translate((playerpos.x - 380), playerpos.y-380)   -- pause menu    
            PauseDraw()  
        end

    end
    Cam_unset()

end

function getslime()
    return slime
end

function reset()

    gravity = vector2.new(0, 100)

    love.window.setTitle("E-sekai") -- windows title
    love.graphics.setBackgroundColor(0.156, 0.886, 0.964) -- background

    Start = returnStart() -- menu
    pause = returnPause() -- menu 

    world_v2 = What_level(inc_level)
    world_load(world,world_v2,windows_size,slime,cannon,shield,sword,king) -- writes the world
    camera = Get_cam()
    sound = Get_sound()

    king = getking()
    player = getplayer()
    Player_start_pos(player,start_point)
    Load_ssheet(player,slime,cannon,king,shield) --this was to be last to load
    LoadMenu(player)

end

function reset_2()

    start_point = vector2.new(-50, -200)
    gravity = vector2.new(0, 100)

    love.window.setTitle("E-sekai") -- windows title
    love.graphics.setBackgroundColor(0.156, 0.886, 0.964) -- background

    Start = returnStart() -- menu
    pause = returnPause() -- menu 
    inc_level = 2

    world_v2 = What_level(inc_level)
    world_load(world,world_v2,windows_size,slime,cannon,shield,sword,king) -- writes the world
    camera = Get_cam()
    sound = Get_sound()

    king = getking()
    player = getplayer()
    Player_start_pos(player,start_point)
    Load_ssheet(player,slime,cannon,king,shield) --this was to be last to load
    LoadMenu(player)
    
end

function reset_3()

    local start_point = vector2.new(-180, 1775)
    gravity = vector2.new(0, 100)

    love.window.setTitle("E-sekai") -- windows title
    love.graphics.setBackgroundColor(0.156, 0.886, 0.964) -- background

    Start = returnStart() -- menu
    pause = returnPause() -- menu 
    inc_level = 3

    world_v2 = What_level(inc_level)
    world_load(world,world_v2,windows_size,slime,cannon,shield,sword,king) -- writes the world
    camera = Get_cam()
    sound = Get_sound()

    king = getking()
    player = getplayer()
    Player_start_pos(player,start_point)
    Load_ssheet(player,slime,cannon,king,shield) --this was to be last to load
    LoadMenu(player)

end

function reset_4()

    local start_point = vector2.new(-180, 1375)
    gravity = vector2.new(0, 100)

    love.window.setTitle("E-sekai") -- windows title
    love.graphics.setBackgroundColor(0.156, 0.886, 0.964) -- background

    Start = returnStart() -- menu
    pause = returnPause() -- menu 
    inc_level = 4

    world_v2 = What_level(inc_level)
    world_load(world,world_v2,windows_size,slime,cannon,shield,sword,king) -- writes the world
    camera = Get_cam()
    sound = Get_sound()

    king = getking()
    player = getplayer()
    Player_start_pos(player,start_point)
    Load_ssheet(player,slime,cannon,king,shield) --this was to be last to load
    LoadMenu(player)

end


function GetInc ()
    return inc_level
end