require "player"
require "invincibility"

local player = {}

function CreateBullets(x, y, dir, r)
    return {position = vector2.new(x, y),
        velocity = vector2.mult(dir, 200),
        radius = r,
        mass = 1,
        maxvelocity = 200,
        spritesheet =  love.graphics.newImage("Assets//cannon//bullet_sprite.png")
        }
end

function UpdateBullets(dt, bullets, plat, cannonposition)
    player = getplayer()
    
    for i = 1, #bullets, 1 do
        if bullets[i] then
            bullets[i].position = vector2.add(bullets[i].position,
                vector2.mult(bullets[i].velocity, dt))
        end
        if bullets[i] then
            local distance = vector2.magni(vector2.sub(cannonposition, bullets[i].position))
            if distance > player.position.x + 500 then -- change the number 500 depending on the  level width
                table.remove(bullets, i)
                return
            end
        end
        for ii = 1, #plat, 1 do
            if bullets[i] then
                local collisiondirection = GetBoxCollisionDirection(bullets[i].position.x - bullets[i].radius,
                    bullets[i].position.y - bullets[i].radius,
                    bullets[i].radius * 2, bullets[i].radius * 2,
                    plat[ii].position.x, plat[ii].position.y,
                    plat[ii].size.x, plat[ii].size.y)
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    table.remove(bullets, i)
                    return
                end
            end
        end
        
        if player.changeAlpha == true then
            player.alphaStart = 0
            player.Palpha = 0
            
            player.alphaStart = player.alphaStart + dt
            if player.alphaStart >= player.alphaTimer then
                player.Palpha = 1
                player.alphaStart = 0
                player.changeAlpha = false
            end
        end
        local collisiondirection = GetBoxCollisionDirection(bullets[i].position.x - bullets[i].radius,
            bullets[i].position.y - bullets[i].radius,
            bullets[i].radius * 2, bullets[i].radius * 2,
            player.position.x, player.position.y,
            player.size.x, player.size.y)
        local collisiondirectionnormalized = vector2.norm(collisiondirection)
        
        if (collisiondirection.x ~= 0 or collisiondirection.y ~= 0) then
            
            --START god mode cheat
            if god_mode == false then
                --START no damage mode cheat
                if no_damage_mode == false then
                    table.remove(bullets, i)
                    invincibility(dt, player)
                    local sound = Get_sound()
                    Play_audio(sound,"player_damage",100,100,false)
                    return
                else
                    end
            --end no damage mode cheat
            else
                end
        --end god mode cheat
        end
    
    end

end

function Drawbullets(bullets)
    for i = 1, #bullets, 1 do
        --love.graphics.circle("fill", bullets[i].position.x, bullets[i].position.y, bullets[i].radius)
        love.graphics.draw(bullets[i].spritesheet,bullets[i].position.x-8.5, bullets[i].position.y-8.5,0,1.5)

    end
end
