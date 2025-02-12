function CreateProjectile(x, y, dir, r)
    return {position = vector2.new(x+20, y),
        velocity = vector2.mult(dir, 10),
        radius = r,
        mass = 1,
        maxvelocity = 150,
        spritesheet = love.graphics.newImage("Assets//Player//bullet_sprite.png")
    }
end

function UpdateProjectiles(dt, projectiles, world, playerposition, cannon, king,shield)
    
    local slime = getslime()
    local sound = Get_sound()
  
    for i = 1, #projectiles, 1 do
   
        if projectiles[i] then
            local lvl3 = GetInc()
            if  lvl3 == 3 or  lvl3 == 4 then 
                projectiles[i].velocity.x = projectiles[i].velocity.x * 1.2
            end
            local distance = vector2.magni(vector2.sub(playerposition, projectiles[i].position))
            if distance > love.graphics.getWidth() + 200 then
                table.remove(projectiles, i)
            end
        end
        
        for ii = 1, #world, 1 do
            if projectiles[i] then
                local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x - projectiles[i].radius,
                    projectiles[i].position.y - projectiles[i].radius,
                    projectiles[i].radius * 2, projectiles[i].radius * 2,
                    world[ii].position.x, world[ii].position.y,
                    world[ii].size.x, world[ii].size.y)
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    table.remove(projectiles, i)
                end
            end
        end
        
        for iii = 1, #slime, 1 do
            if projectiles[i] and slime[iii] then
                local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x - projectiles[i].radius,
                    projectiles[i].position.y - projectiles[i].radius,
                    projectiles[i].radius * 2, projectiles[i].radius * 2,
                    slime[iii].position.x, slime[iii].position.y,
                    slime[iii].size.x, slime[iii].size.y)
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    table.remove(projectiles, i)
                    table.remove(slime, iii)
                    Play_audio(sound,"slime_death",100,60,false)
                end
            end
        end
        
        for s= 1, #shield, 1 do
            if projectiles[i] and shield[s] then
                local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x - projectiles[i].radius,
                    projectiles[i].position.y - projectiles[i].radius,
                    projectiles[i].radius * 2, projectiles[i].radius * 2,
                    shield[s].position.x, shield[s].position.y,
                    shield[s].size.x, shield[s].size.y)
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    table.remove(projectiles, i)
                    shield[s].shieldHP = shield[s].shieldHP -1
                    if   shield[s].shieldHP == 0 then
                        table.remove(shield, s)
                        Play_audio(sound,"shield_death",100,90,false)
                    end
                end
            end
        end
        for C = 1, #cannon, 1 do
            if projectiles[i] then
                local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x - projectiles[i].radius,
                    projectiles[i].position.y - projectiles[i].radius,
                    projectiles[i].radius * 2, projectiles[i].radius * 2,
                    cannon[C].position.x, cannon[C].position.y,
                    cannon[C].size.x, cannon[C].size.y)
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    table.remove(projectiles, i)
                end
            end
        end
        
        if projectiles[i] then
            projectiles[i].position = vector2.add(projectiles[i].position,
                vector2.mult(projectiles[i].velocity, dt))
            projectiles[i].velocity = vector2.limit(projectiles[i].velocity, projectiles[i].maxvelocity)
            
            local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x - projectiles[i].radius,
                projectiles[i].position.y - projectiles[i].radius,
                projectiles[i].radius * 2, projectiles[i].radius * 2,
                king.position.x, king.position.y,
                king.size.x, king.size.y)
            if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                table.remove(projectiles, i)
                king.bossHp = king.bossHp - 1
            end
        end
    end
end

function DrawProjectiles(projectiles)
    for i = 1, #projectiles, 1 do
        
        love.graphics.draw(projectiles[i].spritesheet,projectiles[i].position.x-13, projectiles[i].position.y-13,0,2.5)
    end
end
