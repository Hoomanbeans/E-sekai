require "collision"
require "projectiles"
require "vector2"
require "health"
require "invincibility"

local player = {

        --movement data
        position = vector2.new(100,300),
        velocity = vector2.new(0, 0),
        size = vector2.new(30,63),
        --size = vector2.new(21, 36),
        maxvelocityX = 400,
        maxvelocityY = 550,
        mass = 1,
        frictioncoefficient = 500,
        frictioncoefficient_air = 450,
        onGround = false,
        onAir = false, -- to change the gravity
        jumpforce = 900,
        moveForce = vector2.new(1050, 0),
        dir= vector2.new(1,0),
        --movement data
    
        --direction data
        press_left = false,
        press_right = false,
        --direction data
    
        --pistol data
        projectiles = {}, 
        pistolCd = 0.45, 
        pistolTimer = 0, 
        direction = vector2.new(1, 0),
        --pistol data
    
        --Health / invincibility data
        hp = 3,
        Palpha = 1, --broken
        alphaTimer = 0.1, --broken
        alphaStart = 0, --broken
        changeAlpha = false, --broken
        invincibilityO = 0.5,
        invincibilityS = 0.5,
        color = 0 ,--broken
        --Health / invincibility data
    
        --tiled data idk
        collisiontiles = {},
        --tiled data idk
    
        --audio data
        run_vol = 100,
        run_pitch = 90,
        jump_vol = 100,
        jump_pitch = 50,
        --audio data
    
        --cam data
        off_setx = 380,
        off_sety = 320,
        --cam data
    
        --animation data
        spritesheet = nil,
        spritesheetquads = {},
        animationframe = 1,
        animationframetimer = 0,
        animation_increment_veri = 0.5
        --animation data

}
local moveForce = vector2.new(700, 0)

local press_left = false
local press_right = false
local levels = 1
    

function UpdatePlayer(dt, gravity, world, cannon, king , shield ,sound)
    player.invincibilityS = player.invincibilityS + dt 

    --creating acceleration / applaying gravity to player
    local acceleration = vector2.new(0, 0)
    acceleration = vector2.applyforce(gravity, player.mass, acceleration)
    --end of creating acceleration / applaying gravity to player
    if math.abs(vector2.magni(player.velocity)) > 4 then
        
        --applying ground friction to player
        local friction = vector2.mult(player.velocity, -1)
        friction = vector2.norm(friction)
        friction = vector2.mult(friction, player.frictioncoefficient)
        --end applying ground friction to player

        --applying air friction to player
        local friction_air = vector2.mult(player.velocity, -1)
        friction_air = vector2.norm(friction_air)
        friction_air = vector2.mult(friction_air, player.frictioncoefficient_air)
        --end applying air friction to player

        if (player.onAir == false) then
            acceleration = vector2.applyforce(friction, player.mass, acceleration)
            gravity = vector2.new(0, 100)
        elseif player.onAir == true then --change gravity in the air     
            acceleration = vector2.applyforce(friction_air, player.mass, acceleration)
            gravity.y = gravity.y + (dt*5)
            if gravity.y <=  550 then
                gravity.y = 550
            end
        end
    else
        player.velocity = vector2.new(0, 0)
    end

    

    -- player movement
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        if player.velocity.x <= 0 then
            player.velocity.x = 50
        end
        acceleration = vector2.applyforce(moveForce, player.mass, acceleration)
        player.direction = vector2.new(1, 0)
        press_right = true
    else
        press_right = false
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        if player.velocity.x >= 0 then
            player.velocity.x = -50
        end
        acceleration = vector2.applyforce(vector2.mult(moveForce, -1), player.mass, acceleration)
        player.direction = vector2.new(-1, 0)
        press_left = true
    else
        press_left = false
    end
    if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and player.onGround == true then
        player.velocity.y = player.velocity.y - player.jumpforce
        --infite jump cheat code
        if inf_jump == true or god_mode == true then
            player.onGround = true
        else
            player.onGround = false
        end
    --infite jump cheat code
    end
        player.pistolTimer = player.pistolTimer + dt
        if (love.keyboard.isDown("space") or love.keyboard.isDown("q")) and (player.pistolTimer >= player.pistolCd) then
            player.pistolTimer = 0
            table.insert(player.projectiles, CreateProjectile(player.position.x+10, player.position.y + 30, player.direction, 10))
        end
    
    --end player movement
    local playerdirection = vector2.norm(player.velocity)
    local futurevelocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
    futurevelocity = vector2.limit(futurevelocity, player.maxvelocityX)
    local futureposition = vector2.add(player.position, vector2.mult(futurevelocity, dt))
    
    --Start for loop
    for i = 1, #world, 1 do
        local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x,
            player.size.y, world[i].position.x, world[i].position.y,
            world[i].size.x, world[i].size.y)
        local collisiondirectionnormalized = vector2.norm(collisiondirection)
        if (collisiondirectionnormalized.y == 0) then
            player.onAir = true
        else
            player.onAir = false 
        end
        if (collisiondirectionnormalized.x ~= 0) or (collisiondirectionnormalized.y ~= 0) then
            if (collisiondirectionnormalized.y ~= 0 and playerdirection.y ~= collisiondirectionnormalized.y) then
                --collision on y
                player.velocity.y = 0
                acceleration.y = 0
                
                if collisiondirectionnormalized.y == -1 then -- ground collision from y to -inf_y
                    --START OF GOD MODE IF
                    if god_mode == false then
                        --START OF NO DAMAGE IF
                        if no_damage_mode == false then
                            --checks what obj collided based on the color in platform.lua
                            if world[i].type == "spike" then
                                invincibility(dt, player)
                                player.onGround = true
                                Play_audio(sound,"hit_spike",100,50,false)
                            else
                                player.onGround = true
                            end
                        --checks what obj collided based on the color in platform.lua
                        else
                            player.onGround = true
                        end
                    --START OF NO DAMAGE IF
                    else
                        player.onGround = true
                    end
                --END OF GOD MODE IF
                end -- ground collision from y to -inf_y
                if collisiondirectionnormalized.y == 1 then -- top collision from -y to +inf_y
                    --START OF GOD MODE IF
                    if god_mode == false then
                        --START OF NO DAMAGE IF
                        if no_damage_mode == false then
                            --checks what obj collided based on the color in platform.lua
                            if world[i].type == "spike" then
                                invincibility(dt, player)
                                Play_audio(sound,"hit_spike",100,50,false)
                            else
                                end
                        --checks what obj collided based on the color in platform.lua
                        else
                            end
                    --START OF NO DAMAGE IF
                    else           
                        end
                --END OF GOD MODE IF
                end -- top collision from -y to +inf_y
            end
            
            if (collisiondirectionnormalized.x ~= 0 and playerdirection.x ~= collisiondirectionnormalized.x) then
                --collision on x
                player.velocity.x = 0
                acceleration.x = 0
                --START OF GOD MODE IF
                if god_mode == false then
                    --START OF NO DAMAGE IF
                    if no_damage_mode == false then
                        --checks what obj collided based on the color in platform.lua
                        if world[i].type == "spike" then
                            invincibility(dt, player)
                            Play_audio(sound,"hit_spike",100,50,false)
                        else
                            end
                    --checks what obj collided based on the color in platform.lua
                    else
                        end
                --START OF NO DAMAGE IF
                else
                    end
            --END OF GOD MODE IF
            end
            
            --kils the player immediately apon contact
            if world[i].type == "death_block" then
                player.hp = 0
                player.onGround = false
            end
            --kils the player immediately apon contact
            --adds health to the player immediately apon contact
            if world[i].type == "health_up" then
                player.hp = player.hp + 1
                table.remove(world, i)
                return
            end
            --adds health to the player immediately apon contact
            --changes levels
            if world[i].type == "level+1" then
                
                levels = levels +1
                io.write(levels)

                if levels == 1 then
                    reset()
                elseif levels == 2 then
                    reset_2()
                elseif levels == 3 then
                    reset_3()
                elseif levels == 4 then
                    reset_4()
                 end

                if levels ~= 1 then
                    Stop_audio(sound,"BGM_forest")
                elseif levels ~= 2 then
                    Stop_audio(sound,"BGM_cave")
                elseif levels ~= 3 then
                    Stop_audio(sound,"BGM_boss")
                elseif levels ~= 4 then
                    Stop_audio(sound,"BGM_boss")
                end

            end
            --changes levels
            if math.ceil(collisiondirection.x) ~= 0 then
                player.position.x = player.position.x + collisiondirection.x
            end
            if math.ceil(collisiondirection.y) ~= 0 then
                player.position.y = player.position.y + collisiondirection.y
            end
        end
        
        UpdateProjectiles(dt, player.projectiles, world, player.position, cannon, king,shield)--para a pistola
    end
    --end platform for loop
    for ii = 1, #cannon, 1 do --canhao desde aqui
        local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x,
            player.size.y, cannon[ii].position.x, cannon[ii].position.y,
            cannon[ii].size.x, cannon[ii].size.y)
        local collisiondirectionnormalized = vector2.norm(collisiondirection)
        
        if (collisiondirectionnormalized.x ~= 0) or (collisiondirectionnormalized.y ~= 0) then
            if (collisiondirectionnormalized.y ~= 0 and playerdirection.y ~= collisiondirectionnormalized.y) then
                
                acceleration.y = 0
                if collisiondirectionnormalized.y == -1 then
                    player.onGround = true
                end
            end
            
            if (collisiondirectionnormalized.x ~= 0 and playerdirection.x ~= collisiondirectionnormalized.x) then
                
                player.velocity.x = 0
                acceleration.x = 0
            end
            
            if math.ceil(collisiondirection.x) ~= 0 then
                player.position.x = player.position.x + collisiondirection.x
            end
            
            if math.ceil(collisiondirection.y) ~= 0 then
                player.position.y = player.position.y + collisiondirection.y
            end
        end
    end --canhao ate aqui
    
    --start boss information
    local collisiondirection = GetBoxCollisionDirection(player.position.x, player.position.y, player.size.x,
        player.size.y, king.position.x, king.position.y,
        king.size.x, king.size.y)
    local collisiondirectionnormalized = vector2.norm(collisiondirection)
    
    if (collisiondirection.x ~= 0 or collisiondirection.y ~= 0) then
        --START OF GOD MODE IF
        if god_mode == false and king.die == false then
            --START OF NO DAMAGE IF
            if no_damage_mode == false then
                --checks what obj collided based on the color in platform.lua
                invincibility(dt, player)
            --checks what obj collided based on the color in platform.lua
            end
        --START OF NO DAMAGE IF
        end
        --END OF GOD MODE IF
        if (collisiondirectionnormalized.y ~= 0 and playerdirection.y ~= collisiondirectionnormalized.y) then
            player.velocity.y = 0
            acceleration.y = 0
            if collisiondirectionnormalized.y == -1 then
                player.onGround = true
            end
        end
        if (collisiondirectionnormalized.x ~= 0 and playerdirection.x ~= collisiondirectionnormalized.x) then
            player.velocity.x = 0
            acceleration.x = 0
            player.velocity.x = -175
        end
        if math.ceil(collisiondirection.x) ~= 0 then
            player.position.x = player.position.x + collisiondirection.x
        end
        if math.ceil(collisiondirection.y) ~= 0 then
            player.position.y = player.position.y + collisiondirection.y
        end
    end
    --start boss information
    player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
    if player.direction.x == 1 then -- player max velocity in the x 

    if player.velocity.x >= player.maxvelocityX then 
        player.velocity.x = player.maxvelocityX
    
    end
    elseif player.direction.x == -1 then -- player max velocity in the x 

    if (player.velocity.x * -1 )>= player.maxvelocityX then 
        player.velocity.x = -player.maxvelocityX
    end 
end

    if (player.velocity.y * -1) >= player.maxvelocityY then 
       player.velocity.y = -player.maxvelocityY
    end

    player.position = vector2.add(player.position, vector2.mult(player.velocity, dt))

    UpdateAnimationFrame(sound,player,dt)

    io.write(levels)
end

function DrawPlayer()
    ---love.graphics.setColor(0, 0, 1, player.Palpha)
    --love.graphics.rectangle("fill", player.position.x, player.position.y, player.size.x, player.size.y)
    love.graphics.draw(player.spritesheet,player.spritesheetquads[player.animationframe],player.position.x-12,player.position.y-17,0,1.45)
    --love.graphics.setColor(1, 1, 1)
end

function UpdateAnimationFrame(sound,player, dt)

    --player.invincibilityS = player.invincibilityS + dt

    local magx = math.abs(vector2.magni(vector2.new(player.velocity.x,0)))
    local magy = math.abs(vector2.magni(vector2.new(player.velocity.y,0)))
    local Norm = vector2.norm(player.velocity)
    
	if Norm.x > 0 then --player is moving right
		if Norm.y > 0 then
			if player.animationframe < 29 or player.animationframe > 31 then
				player.animationframe = 29
				player.animationframetimer = 0
			end
            player.animationframetimer = player.animationframe + dt
            if player.animationframetimer > player.animation_increment_veri then
                if player.animationframe == 29 then
                player.animationframe = player.animationframe
                else
                    player.animationframe = player.animationframe + 1
                end
            end
            player.animationframetimer = 0
		elseif Norm.y < 0 then
			if player.animationframe < 32 or player.animationframe > 35 then
				player.animationframe = 32
				player.animationframetimer = 0
			end
            player.animationframetimer = player.animationframe + dt
            if player.animationframetimer > player.animation_increment_veri then
                if player.animationframe == 32 then
                player.animationframe = player.animationframe
                else
                    player.animationframe = player.animationframe + 1
                end
            end
            player.animationframetimer = 0
		else
            if player.animationframe < 1 or player.animationframe > 7 then
				player.animationframe = 1
				player.animationframetimer = 0
			end
			player.animationframetimer = player.animationframetimer + dt
			if player.animationframetimer > player. animation_increment_veri then
				player.animationframe = player.animationframe + 1
				if player.animationframe > 7 then
					player.animationframe = 1
				end
				player.animationframetimer = 0
			end
		end
    elseif Norm.x < 0 then -- player is moving left

		if Norm.y > 0 then --before apex of the jump
            if player.animationframe < 36 or player.animationframe > 39 then
				player.animationframe = 36
				player.animationframetimer = 0
			end
            player.animationframetimer = player.animationframe + dt
            if player.animationframetimer > player.animation_increment_veri then
                if player.animationframe == 39 then
                player.animationframe = player.animationframe
                else
                    player.animationframe = player.animationframe + 1
                end
            end
            player.animationframetimer = 0

        elseif Norm.y < 0 then --when after apex of the jump
            
            if player.animationframe < 39 or player.animationframe > 42 then
				player.animationframe = 39
				player.animationframetimer = 0
			end
            player.animationframetimer = player.animationframe + dt
            if player.animationframetimer > player.animation_increment_veri then
                if player.animationframe == 42 then
                player.animationframe = player.animationframe
                else
                    player.animationframe = player.animationframe + 1
                end
            end
            player.animationframetimer = 0
		else	
			if player.animationframe < 8 or player.animationframe > 16 then
				player.animationframe = 8
				player.animationframetimer = 0
			end
		
			player.animationframetimer = player.animationframetimer + dt
			if player.animationframetimer > player. animation_increment_veri then
				player.animationframe = player.animationframe + 1
				
				if player.animationframe > 16 then
					player.animationframe = 8
				end
				player.animationframetimer = 0
			end
        end
    
	end

	if  magx < 200 then
		if player.onGround == true then
		    Play_audio(sound,"run_grass",player.run_vol,player.run_pitch)
		end
        player. animation_increment_veri = 0.5
        if magx < 30 then --idle animation
        player. animation_increment_veri = 0.1

            
            if player.animationframe < 17 or player.animationframe > 28 then
                player.animationframe = 17
                player.animationframetimer = 0
            end
        
            player.animationframetimer = player.animationframetimer + dt
            if player.animationframetimer > player. animation_increment_veri then
                player.animationframe = player.animationframe + 1
                
                if player.animationframe > 28 then
                    player.animationframe = 17
                end
                player.animationframetimer = 0
            end
			Stop_audio(sound,"run_grass")
		end
	elseif magx < 300 then
		if player.onGround== true then
			Play_audio(sound,"run_grass",player.run_vol,player.run_pitch)
			end
        player. animation_increment_veri= 0.4
	elseif magx <=450 then
		if player.onGround== true then
			Play_audio(sound,"run_grass",player.run_vol,player.run_pitch)
			end
		player. animation_increment_veri= 0.3
    end

	return player
end

function Player_start_pos(player,start_point)
    player.position.x = start_point.x
    player.position.y = start_point.y
end

function GetPlayerPosition()
    return player.position
end

function getplayer()
    return player
end
