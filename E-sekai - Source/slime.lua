require "collision"
require "vector2"

function CreateSlimes(x, y, v_x)

    return {
        position = vector2.new(x, y), 
        size = vector2.new(40,30),
        velocity = vector2.new(0, 0), 
        maxvelocity = 300, mass = 1,
        frictionCoenficient = 150,
        gravity = vector2.new(0, 600), 
        moveRight = vector2.new(v_x, 0),
        spritesheet =  nil,
        spritesheetquads = {},
        animationframe = 1,
        animationframetimer = 0,
        animation_increment_veri = 0.1
    }
end

function UpdateSlime(dt, gravity, world, slime, player)

    local sound = Get_sound()
    
    for i = 1, #slime, 1 do
        
        local acceleration = vector2.new(0, 0)
        acceleration = vector2.applyforce(slime[i].moveRight, slime[i].mass, acceleration)
        acceleration = vector2.applyforce(gravity, slime[i].mass, acceleration)
        if math.abs(vector2.magni(slime[i].velocity)) > 4 then
            
            local friction = vector2.mult(slime[i].velocity, -1)
            friction = vector2.norm(friction)
            friction = vector2.mult(friction, slime[i].frictionCoenficient)
            
            if (slime[i].onGround == true) then
                acceleration = vector2.applyforce(friction, slime[i].mass, acceleration)
            end
        else
            slime[i].velocity = vector2.new(0, 0)
        end
        
        local slimedirection = vector2.norm(slime[i].velocity)
        local futurevelocity = vector2.add(slime[i].velocity, vector2.mult(acceleration, dt))
        futurevelocity = vector2.limit(futurevelocity, slime[i].maxvelocity)
        local futureposition = vector2.add(slime[i].position, vector2.mult(futurevelocity, dt))
        
        for ii = 1, #world, 1 do
            
            local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, slime[i].size.x,
                slime[i].size.y, world[ii].position.x, world[ii].position.y,
                world[ii].size.x, world[ii].size.y)
            local collisiondirectionnormd = vector2.norm(collisiondirection)
            
            if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
                if (collisiondirectionnormd.y ~= 0 and slimedirection.y ~= collisiondirectionnormd.y) then
                    slime[i].velocity.y = 0
                    acceleration.y = 0
                    if collisiondirectionnormd.y == -1 then
                        slime[i].onGround = true
                    end
                end
                
                if (collisiondirectionnormd.x ~= 0 and slimedirection.x ~= collisiondirectionnormd.x) then
                    slime[i].moveRight = vector2.mult(slime[i].moveRight, -1)
                    slime[i].velocity.x = 0
                    acceleration.x = 0

                end
                
                if math.ceil(collisiondirection.x) ~= 0 then
                    slime[i].position.x = slime[i].position.x + collisiondirection.x
                end
                
                if math.ceil(collisiondirection.y) ~= 0 then
                    slime[i].position.y = slime[i].position.y + collisiondirection.y
                end
            end
        end

        if slime[i].moveRight.x > 0 then 
            if slime[i].animationframe > 8 then
                slime[i].animationframe = 1
            end
    
            slime[i].animationframetimer = slime[i].animationframetimer + dt
            if slime[i].animationframetimer > 0.1 then
                slime[i].animationframe = slime[i].animationframe +1
                if slime[i].animationframe > 8 then   
                    slime[i].animationframe = 1
                end
                slime[i].animationframetimer = 0
            end        
        else
            if slime[i].animationframe  < 9 then
                slime[i].animationframe = 9
            end
    
            slime[i].animationframetimer = slime[i].animationframetimer + dt
            if slime[i].animationframetimer > 0.1 then
                slime[i].animationframe = slime[i].animationframe +1
                if slime[i].animationframe > 16 then   
                    slime[i].animationframe = 9
                end
                slime[i].animationframetimer = 0
            end        
        end
        
        --player and slime collisions only
        local player_collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, slime[i].size.x,
            slime[i].size.y, player.position.x, player.position.y,
            player.size.x, player.size.y)
        local collisiondirectionnormd = vector2.norm(player_collisiondirection)
        
        if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
            
            if (collisiondirectionnormd.y ~= 0 and slimedirection.y ~= collisiondirectionnormd.y) then
                slime[i].velocity.y = 0
                acceleration.y = 0
                if collisiondirectionnormd.y == -1 then
                    slime[i].onGround = true
                end
                
                if collisiondirectionnormd.y == 1 then
                    
                    --start god mode mode cheat
                    if god_mode == false then
                        --start no damage mode cheat
                        if no_damage_mode == false then
                            player.velocity.y = -200
                            player.onGround = true
                            table.remove(slime, i)
                            Play_audio(sound,"slime_death",100,100,false)
                            return --needs to be so its stop for calculation for that slime
                        else
                            table.remove(slime, i)
                            return --needs to be so its stop for calculation for that slime
                        end
                    --end no damage mode cheat
                    else
                        table.remove(slime, i)
                        return --needs to be so its stop for calculation for that slime
                    end
                --end of god mode mode cheat
                end
            end
            
            if (collisiondirectionnormd.x ~= 0 and slimedirection.x ~= collisiondirectionnormd.x) then
                --start god mode mode cheat
                if god_mode == false then
                    --start no damage mode cheat
                    if no_damage_mode == false then
                        invincibility(dt, player)
                    end
                --start no damage mode cheat
                end
            --start god mode mode cheat
            end
            
            if math.ceil(player_collisiondirection.x) ~= 0 then
                slime[i].position.x = slime[i].position.x + player_collisiondirection.x
            end
            
            if math.ceil(player_collisiondirection.y) ~= 0 then
                slime[i].position.y = slime[i].position.y + player_collisiondirection.y
            end
        end
        --player and slime collisions only
        slime[i].velocity = vector2.add(slime[i].velocity, vector2.mult(acceleration, dt))
        slime[i].velocity = vector2.limit(slime[i].velocity, slime[i].maxvelocity)
        slime[i].position = vector2.add(slime[i].position, vector2.mult(slime[i].velocity, dt))
    end
end

function DrawSlime(slime)
    for i = 1, #slime, 1 do
        --love.graphics.setColor(1,1,1)
        --·love.graphics.rectangle("line", slime[i].position.x, slime[i].position.y, slime[i].size.x, slime[i].size.y)
        love.graphics.draw(slime[i].spritesheet,slime[i].spritesheetquads[slime[i].animationframe],slime[i].position.x-20,slime[i].position.y-28,0,2)
        --love.graphics.draw(slime[i].spritesheet,10*i,200)
        --love.graphics.setColor(0, 0, 0)
    end
end

function Load_slime(slime)

    slime[1] = CreateSlimes(200, 300, 500)
    slime[2] = CreateSlimes(250, 300, 300)
    slime[3] = CreateSlimes(300, 300, 400)

end
