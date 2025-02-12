require "collision"

function CreateShield (x,y,p)
    return {position = vector2.new(x,y),
    size = vector2.new(50,100),
    velocity=vector2.new(0,0),
    maxvelocity= 150,
    mass =1,
    moveForce =vector2.new(240,0),
    dir = vector2.new(1,0),
    frictionCoenficient = 150,
    color = 1,
    alarmPosition = vector2.new(x,y),
    alarmsize = vector2.new(300,100),
    dash = 4.5,
    dashActivated = false,
    shieldHP = 4,
    onGround = false,
    turnback = 1,

    --animation data
        spritesheet =  nil,
        spritesheetquads = {},
        animationframe = 1,
        animationframetimer = 0,
        animation_increment_veri = 0.1
    --animation data
}
end


function  UpdateShield(dt,shield,gravity,world,player)
    for i= 1 , #shield , 1 do 
        shield[i].turnback = shield[i].turnback - dt 
        local acceleration = vector2.new(0, 0)
        acceleration = vector2.applyforce(shield[i].moveForce, shield[i].mass, acceleration)
        acceleration = vector2.applyforce(gravity, shield[i].mass, acceleration)

        if math.abs(vector2.magni(shield[i].velocity)) > 4 then
            
            local friction = vector2.mult(shield[i].velocity, -1)
            friction = vector2.norm(friction)
            friction = vector2.mult(friction, shield[i].frictionCoenficient)
            
            if (shield[i].onGround == true) then
                acceleration = vector2.applyforce(friction, shield[i].mass, acceleration)
            end
        else
            shield[i].velocity = vector2.new(0, 0)
        end
        local shielddirection = vector2.norm(shield[i].velocity)
        local futurevelocity = vector2.add(shield[i].velocity, vector2.mult(acceleration, dt))
        futurevelocity = vector2.limit(futurevelocity, shield[i].maxvelocity)
        local futureposition = vector2.add(shield[i].position, vector2.mult(futurevelocity, dt))

        
        for ii = 1, #world, 1 do
            
            local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, shield[i].size.x,
                                                                shield[i].size.y, world[ii].position.x, world[ii].position.y,
                                                                world[ii].size.x, world[ii].size.y)
            local collisiondirectionnormd = vector2.norm(collisiondirection)
            
            if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
                if (collisiondirectionnormd.y ~= 0 and shielddirection.y ~= collisiondirectionnormd.y) then
                    shield[i].velocity.y = 0
                    acceleration.y = 0
                    if collisiondirectionnormd.y == -1 then
                        shield[i].onGround = true
                    end
                end
                
                if (collisiondirectionnormd.x ~= 0 and shielddirection.x ~= collisiondirectionnormd.x) then
                   -- if shield[i].dashActivated == false then 
                    shield[i].moveForce = vector2.mult(shield[i].moveForce, -1)
                  --  end
                    shield[i].velocity.x = 0
                    acceleration.x = 0
                    shield[i].dir.x = shield[i].dir.x * -1
                    io.write(shield[i].dir.x)
                end
                
                if math.ceil(collisiondirection.x) ~= 0 then
                    shield[i].position.x = shield[i].position.x + collisiondirection.x
                end
                
                if math.ceil(collisiondirection.y) ~= 0 then
                    shield[i].position.y = shield[i].position.y + collisiondirection.y
                end
            end
            
        end
     local collisiondirection = GetBoxCollisionDirection(shield[i].position.x , shield[i].position.y,shield[i].size.x,     -- player collision
                                                        shield[i].size.y,player.position.x, player.position.y,
                                                        player.size.x, player.size.y)
     local collisiondirectionnormd = vector2.norm(collisiondirection)
    

        if (collisiondirectionnormd.x ~= 0) or (collisiondirectionnormd.y ~= 0) then
        if (collisiondirectionnormd.y ~= 0 and shielddirection.y ~= collisiondirectionnormd.y) then

            shield[i].velocity.y = 0
            acceleration.y = 0
        end

        if (collisiondirectionnormd.x ~= 0 and shielddirection.x ~= collisiondirectionnormd.x) then

            if god_mode == false then
                --start no damage mode cheat
                if no_damage_mode == false then
                    invincibility(dt, player)
                    shield[i].velocity.x = 0
                    acceleration.x = 0
                end
            end
            
        end

        if (collisiondirectionnormd.x ==1) then
            if god_mode == false then
                --start no damage mode cheat
                if no_damage_mode == false then
                    player.velocity.x = -300
                    invincibility(dt, player)
                end
            end

        elseif (collisiondirectionnormd.x ==-1) then
            if god_mode == false then
                --start no damage mode cheat
                if no_damage_mode == false then
                    player.velocity.x = 300
                    invincibility(dt, player)
                end
            end
        end

        if collisiondirectionnormd.y == 1 then
        player.velocity.y = -500
        end


        if math.ceil(collisiondirection.x) ~= 0 then
        shield[i].position.x = shield[i].position.x + collisiondirection.x
        end
        if shield[i] then

        if math.ceil(collisiondirection.y) ~= 0 then
        shield[i].position.y = shield[i].position.y + collisiondirection.y
        end
        end
        end
        
        if shield[i] then

        if shield[i].dir.x == 1 then 
        local collisiondirection = GetBoxCollisionDirection(shield[i].position.x + 50, shield[i].position.y+20,shield[i].alarmsize.x,   
                                                            shield[i].size.y,player.position.x, player.position.y,
                                                           player.size.x, player.size.y)
             local collisiondirectionnormd = vector2.norm(collisiondirection)       
            if collisiondirectionnormd.x ~= 0 or collisiondirectionnormd.y ~= 0 then
                shield[i].maxvelocity = 500
                shield[i].velocity = vector2.add(shield[i].velocity, vector2.mult(shield[i].dir, shield[i].dash))
                shield[i].color = 0
                shield[i].dashActivated = true
    
            else
               
                shield[i].dashActivated = false
            end         
        -- end here
        elseif shield[i].dir.x == -1 then 
            local collisiondirection = GetBoxCollisionDirection(shield[i].position.x - shield[i].alarmsize.x, shield[i].position.y+10,shield[i].alarmsize.x,
                                                            shield[i].size.y,player.position.x, player.position.y,
                                                           player.size.x, player.size.y)
             local collisiondirectionnormd = vector2.norm(collisiondirection)       
            if collisiondirectionnormd.x ~= 0 or collisiondirectionnormd.y ~= 0 then
                shield[i].maxvelocity = 500
                shield[i].velocity = vector2.add(shield[i].velocity, vector2.mult(shield[i].dir, shield[i].dash))
                shield[i].color = 0
                shield[i].dashActivated = true
            else
               
                shield[i].dashActivated = false
            end     
        end   
        end 

        shield[i].velocity = vector2.add(shield[i].velocity, vector2.mult(acceleration, dt))
        shield[i].velocity = vector2.limit(shield[i].velocity,shield[i].maxvelocity)
        shield[i].position = vector2.add(shield[i].position, vector2.mult(shield[i].velocity, dt))                
        
        if shield[i].moveForce.x > 0 then 
            if shield[i].animationframe > 8 then
                shield[i].animationframe = 1
            end
    
            shield[i].animationframetimer = shield[i].animationframetimer + dt
            if shield[i].animationframetimer > 0.1 then
                shield[i].animationframe = shield[i].animationframe +1
                if shield[i].animationframe > 8 then   
                    shield[i].animationframe = 1
                end
                shield[i].animationframetimer = 0
            end        
            else
            if shield[i].animationframe  < 9 then
                shield[i].animationframe = 9
            end
    
            shield[i].animationframetimer = shield[i].animationframetimer + dt
            if shield[i].animationframetimer > 0.1 then
                shield[i].animationframe = shield[i].animationframe +1
                if shield[i].animationframe > 16 then   
                    shield[i].animationframe = 9
                end
                shield[i].animationframetimer = 0
            end        

    end

end

end
function DrawShield(shield)
    for i= 1 , #shield , 1 do 

        love.graphics.draw(shield[i].spritesheet,shield[i].spritesheetquads[shield[i].animationframe],shield[i].position.x-20,shield[i].position.y-28,0,1.5 )

    end   
end
