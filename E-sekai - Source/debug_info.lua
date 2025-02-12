require "player"

local S_platnumb = ""
local S_ndm = ""
local S_GOD = ""
local S_infj = ""

local stp_debug_m = 90

--GLOBAL boleans used to debug game
show_plat_number = false
--GLOBAL boleans used to debug game
--GLOBAL bolean used in cheat codes
no_damage_mode = false
god_mode = false
inf_jump = false
--GLOBAL bolean used in cheat codes



function Status_modes(player, start_pos)
    
    --indicadores do status do cheat
    if no_damage_mode == true then
        S_ndm = "ON"
    else
        S_ndm = "off"
    end
    
    if god_mode == true then
        S_GOD = "ON"
    else
        S_GOD = "off"
    end
    
    if show_plat_number == true then
        S_platnumb = "ON"
    else
        S_platnumb = "off"
    end
    
    if inf_jump == true then
        S_infj = "ON"
    else
        S_infj = "off"
    end
    --indicadores do status do cheat
    --debug actions
    function love.keypressed(key)
        
 
        
        if key == "2" then
            --no_damage_mode on/off
            if no_damage_mode == true then
                no_damage_mode = false
            else
                no_damage_mode = true
            end
        --no_damage_mode on/off
        end
        
        if key == "3" then
            --inf_jump on/off
            if inf_jump == true then
                inf_jump = false
            else
                inf_jump = true
            end
        --inf_jump on/off
        end
        
        if key == "4" then
            --god_mode on/off
            if god_mode == true then
                god_mode = false
            else
                god_mode = true
            end
        --god_mode on/off
        end
        
        if key == "5" then
            player.position = start_pos
        end
        
        if key == "6" then
            player.position.x = 5250
        end
        
 
    
    end
--debug actions
end

function Show_menu()
    
    local playerpos_debug = GetPlayerPosition()
    
    --show in corner keyboard option to debug game
    --love.graphics.setColor(1, 1, 1)
    
    love.graphics.print("1 - show platform numbers: " .. S_platnumb, (playerpos_debug.x - 350), stp_debug_m)
    love.graphics.print("2 - no damage mode: " .. S_ndm, (playerpos_debug.x - 350), stp_debug_m + 12)
    love.graphics.print("3 - infinite jumps: " .. S_infj, (playerpos_debug.x - 350), stp_debug_m + 25)
    love.graphics.print("4 - GOD MODE: " .. S_GOD, (playerpos_debug.x - 350), stp_debug_m + 40)
    love.graphics.print("5 - Teleport to beggining ", (playerpos_debug.x - 350), stp_debug_m + 55)
    love.graphics.print("6 - Teleport to middle of map ", (playerpos_debug.x - 350), stp_debug_m + 70)
    love.graphics.print("7 - Teleport to boss room ", (playerpos_debug.x - 350), stp_debug_m + 85)
    
    --love.graphics.setColor(0, 0, 0)
--show in corner keyboard option to debug game
end
