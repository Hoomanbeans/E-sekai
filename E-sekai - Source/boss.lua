require "collision"
require "vector2"
require "king"
require "invincibility"

function CreatSwords(x, y, w, h, vx, vy, t)
    return {position = vector2.new(x, y),
        size = vector2.new(w, h),
        velocity = vector2.new(vx, vy),
        maxvelocity = 500, mass = 1,
        onGround = false,
        StartTime = 0, OverTime = t,
        Gotime = false,
        alpha = 1,
        StartPosition = vector2.new(x, y),
        SwordSequence = 1,
        phase2 = false,
        phase3 = false,
        moveForce = vector2.new(400, 0),
        frictionCoenficient = 300,
        swords = love.graphics.newImage("Assets/Boss/sword_boss.png")
    }
end

function Createswords_v2(x, y,vx,vy,t)
    return {position = vector2.new(x, y),
        size = vector2.new(32, 64),
        velocity = vector2.new(vx, vy),
        maxvelocity = 500, mass = 1,
        onGround = false,
        StartTime = 0, OverTime = t,
        Gotime = false,
        alpha = 1,
        StartPosition = vector2.new(x, y),
        SwordSequence = 1,
        phase2 = false,
        phase3 = false,
        moveForce = vector2.new(400, 0),
        frictionCoenficient = 300,
    }
end

function LoadSwords()


end

function UpdateSwords(dt, swords, plat, gravity, player, king)
    
        for i = 1, 7, 1 do
            
            ChangeVisual(dt, player)
            
            if king.die == true then
                table.remove(swords, i)
                return
            else
                swords[i].StartTime = swords[i].StartTime + dt
                if swords[i].StartTime > swords[i].OverTime[swords[i].SwordSequence] then
                    swords[i].Gotime = true
                elseif swords[i].StartTime < swords[i].OverTime[swords[i].SwordSequence] then
                    swords[i].Gotime = false
                end
                local acceleration = vector2.new(0, 0)
                if swords[i].onGround == false and swords[i].Gotime == true then
                    acceleration = vector2.applyforce(gravity, swords[i].mass, acceleration)
                end
                swords[i].velocity = vector2.add(swords[i].velocity, vector2.mult(acceleration, dt))
                swords[i].velocity = vector2.limit(swords[i].velocity, swords[i].maxvelocity)
                swords[i].position = vector2.add(swords[i].position, vector2.mult(swords[i].velocity, dt))
                
                local swordsDirection = vector2.norm(swords[i].velocity)
                local futurevelocity = vector2.add(swords[i].velocity, vector2.mult(acceleration, dt))
                futurevelocity = vector2.limit(futurevelocity, swords[i].maxvelocity)
                local futureposition = vector2.add(swords[i].position, vector2.mult(futurevelocity, dt))
                
                
                local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, swords[i].size.x,
                    swords[i].size.y, player.position.x, player.position.y,
                    player.size.x, player.size.y)
                if (collisiondirection.x ~= 0 or collisiondirection.y ~= 0) and swords[i].alpha >= 0.8 then
                    --START OF GOD MODE IF
                    if god_mode == false then
                        --START OF NO DAMAGE IF
                        if no_damage_mode == false then
                            --checks what obj collided based on the color in platform.lua
                            invincibility(dt, player)
                        --checks what obj collided based on the color in platform.lua
                        end
                    --START OF NO DAMAGE IF
                    end
                --END OF GOD MODE IF
                end
                
                
                for ii = 1, #plat, 1 do
                    
                    local collisiondirection = GetBoxCollisionDirection(swords[i].position.x, swords[i].position.y, swords[i].size.x,
                        swords[i].size.y, plat[ii].position.x, plat[ii].position.y,
                        plat[ii].size.x, plat[ii].size.y)
                    local collisiondirectionnormd = vector2.norm(collisiondirection)
                    
                    if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
                        if (collisiondirectionnormd.y ~= 0 and swordsDirection.y ~= collisiondirectionnormd.y) then
                            
                            swords[i].velocity.y = 0
                            acceleration.y = 0
                            
                            if collisiondirectionnormd.y == -1 then
                                swords[i].onGround = true
                                swords[i].alpha = swords[i].alpha - (1.5 * dt)
                            
                            end
                        end
                        
                        if (collisiondirectionnormd.x ~= 0 and swordsDirection.x ~= collisiondirectionnormd.x) then
                            
                            swords[i].moveForce = vector2.mult(swords[i].moveForce, -1)
                            swords[i].velocity.x = 0
                            acceleration.x = 0
                        end
                        
                        if math.ceil(collisiondirection.x) ~= 0 then
                            swords[i].position.x = swords[i].position.x + collisiondirection.x
                        end
                        
                        if math.ceil(collisiondirection.y) ~= 0 then
                            swords[i].position.y = swords[i].position.y + collisiondirection.y
                        end
                    end
                    if swords[i].alpha <= 0 then
                        swords[i].alpha = 1
                        swords[i].position = swords[i].StartPosition
                        swords[i].onGround = false
                        swords[i].StartTime = 0
                        swords[i].SwordSequence = swords[i].SwordSequence + 1
                        if swords[i].SwordSequence > #swords[i].OverTime then
                            swords[i].SwordSequence = 1
                        end
                    end
                end
            end
        end
        
        for i = 8, 8, 1 do
            
            local acceleration = vector2.new(0, 0)
            local futurevelocity = vector2.add(swords[i].velocity, vector2.mult(acceleration, dt))
            
            futurevelocity = vector2.limit(futurevelocity, swords[i].maxvelocity)
            
            local futureposition = vector2.add(swords[i].position, vector2.mult(futurevelocity, dt))
            
            local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, swords[i].size.x,
                swords[i].size.y, player.position.x, player.position.y,
                player.size.x, player.size.y)
            
            
            if (collisiondirection.x ~= 0 or collisiondirection.y ~= 0) and swords[i].alpha >= 0.8 then
                --START OF GOD MODE IF
                if god_mode == false then
                    --START OF NO DAMAGE IF
                    if no_damage_mode == false then
                        --checks what obj collided based on the color in platform.lua
                        invincibility(dt, player)
                    --checks what obj collided based on the color in platform.lua
                    end
                --START OF NO DAMAGE IF
                end
            --END OF GOD MODE IF
            end
            
            if king.bossHp <= 35 then
                swords[i].phase2 = true
                king.color = 0.5
                swords[i].position.y = 480
            
            end
            
            if king.bossHp <= 15 then
                swords[i].phase2 = false
                swords[i].phase3 = true
                swords[i].position = vector2.new(900, 900)
            end
            
            
            if swords[i].phase2 == true and swords[i].phase3 ~= true then
                swords[i].position = vector2.add(swords[i].position, vector2.mult(swords[i].velocity, dt))
                if swords[i].position.x <= king.position.x - 1000 --[[love.graphics.getWidth()]] then
                    swords[i].position = swords[i].StartPosition
                end
            end
        
        
        end
        
        for i = 9, 10, 1 do
            if king.bossHp <= 15 then
                swords[i].phase3 = true
                king.color = 1
            end
            if swords[i].phase3 == true  then
                local acceleration = vector2.new(0, 0)
                
                acceleration = vector2.applyforce(swords[i].moveForce, swords[i].mass, acceleration)
                acceleration = vector2.applyforce(gravity, swords[i].mass, acceleration)
                
                if math.abs(vector2.magni(swords[i].velocity)) > 4 then
                    local friction = vector2.mult(swords[i].velocity, -1)
                    friction = vector2.norm(friction)
                    friction = vector2.mult(friction, swords[i].frictionCoenficient)
                    acceleration = vector2.applyforce(friction, swords[i].mass, acceleration)
                end
                local swordsdirection = vector2.norm(swords[i].velocity)
                local futurevelocity = vector2.add(swords[i].velocity, vector2.mult(acceleration, dt))
                futurevelocity = vector2.limit(futurevelocity, swords[i].maxvelocity)
                local futureposition = vector2.add(swords[i].position, vector2.mult(futurevelocity, dt))
                for ii = 1, #plat, 1 do
                    
                    local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, swords[i].size.x,
                        swords[i].size.y, plat[ii].position.x, plat[ii].position.y,
                        plat[ii].size.x, plat[ii].size.y)
                    local collisiondirectionnormd = vector2.norm(collisiondirection)
                    if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
                        if (collisiondirectionnormd.y ~= 0 and swordsdirection.y ~= collisiondirectionnormd.y) then
                            
                            swords[i].velocity.y = 0
                            acceleration.y = 0
                        
                        end
                        
                        if (collisiondirectionnormd.x ~= 0 and swordsdirection.x ~= collisiondirectionnormd.x) then
                            
                            swords[i].moveForce = vector2.mult(swords[i].moveForce, -1)
                            swords[i].velocity.x = 0
                            acceleration.x = 0
                        end
                        
                        if math.ceil(collisiondirection.x) ~= 0 then
                            swords[i].position.x = swords[i].position.x + collisiondirection.x
                        end
                        
                        if math.ceil(collisiondirection.y) ~= 0 then
                            swords[i].position.y = swords[i].position.y + collisiondirection.y
                        end
                    end
                end
                
                local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, swords[i].size.x,
                    swords[i].size.y, player.position.x, player.position.y,
                    player.size.x, player.size.y)
                
                
                if (collisiondirection.x ~= 0 or collisiondirection.y ~= 0) and swords[i].alpha >= 0.8 then
                    --START OF GOD MODE IF
                    if god_mode == false then
                        --START OF NO DAMAGE IF
                        if no_damage_mode == false then
                            --checks what obj collided based on the color in platform.lua
                            invincibility(dt, player)
                            player.alphaStart = player.alphaStart + dt
                        --checks what obj collided based on the color in platform.lua
                        end
                    --START OF NO DAMAGE IF
                    end
                --END OF GOD MODE IF
                end
                swords[i].velocity = vector2.add(swords[i].velocity, vector2.mult(acceleration, dt))
                swords[i].velocity = vector2.limit(swords[i].velocity, swords[i].maxvelocity)
                swords[i].position = vector2.add(swords[i].position, vector2.mult(swords[i].velocity, dt))
            end
        end
    
    end




function DrawSwords(swords, king)
    if king.die == false then
        local lvl3 = GetInc()
        if  lvl3 == 3 or  lvl3 == 4 then 
           
        for i = 1, 7, 1 do
            love.graphics.setColor(1, 1, 1, swords[i].alpha)
            love.graphics.draw(swords[i].swords,swords[i].position.x, swords[i].position.y,0,1.5,1.5)
            love.graphics.setColor(0, 0, 0, swords[i].alpha)
            
          
        end
        for i = 8, 8, 1 do
            if swords[i].phase2 == true then
                love.graphics.setColor(1, 1, 1, swords[i].alpha)
                love.graphics.draw(swords[i].swords,swords[i].position.x, swords[i].position.y,0,1.5,1.5)
                love.graphics.setColor(1, 1, 1)
            end
        end
        for i = 9, 10, 1 do
            if swords[i].phase3 == true then
                love.graphics.setColor(1, 1, 1, swords[i].alpha)
                love.graphics.draw(swords[i].swords,swords[i].position.x, swords[i].position.y,0,1.5,1.5)
                love.graphics.setColor(1, 1, 1)
                
            end
        end
    
        love.graphics.setColor(1,1,1,1)
    
    else
        return
    end
end
end
