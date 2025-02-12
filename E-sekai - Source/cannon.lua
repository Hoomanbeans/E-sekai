require "collision"
require "vector2"
require "bullets"

local Font_n_plataforma = love.graphics.newFont(20)
local Font_default = love.graphics.newFont(12)

function CreateCannon(x, y, x_dir, y_dir,anim_frame)

    return {position = vector2.new(x, y), 
    size = vector2.new(32, 32),
        bullets = {},
        bulletslCd = 2,
        bulletsTimer = 0,
        cannonDirection = vector2.new(x_dir, y_dir),-- (x,y)
        spritesheet = nil,
        spritesheetquads = {},
        animationframe = anim_frame
    }
end

function CreateCannon_V2(x, y, x_dir, y_dir, cd_time)
    
    return {position = vector2.new(x, y), size = vector2.new(32, 32),
        bullets = {},
        bulletslCd = cd_time,
        bulletsTimer = 0,
        cannonDirection = vector2.new(x_dir, y_dir),-- (x,y)
        spritesheet = nil,
        spritesheetquads = {},
        animationframe = 1
    }
end

function UpdateCannon(dt, plat, cannon)
    for i = 1, #cannon, 1 do
        if cannon[i] == nil then
            return
        else
            cannon[i].bulletsTimer = cannon[i].bulletsTimer + dt
            if (cannon[i].bulletsTimer >= cannon[i].bulletslCd) then
                cannon[i].bulletsTimer = 0         
                --CHANGE BULLET RAIDUS HERE
                table.insert(cannon[i].bullets, CreateBullets(cannon[i].position.x + (cannon[i].size.x / 2), cannon[i].position.y + (cannon[i].size.y / 2),
                    cannon[i].cannonDirection, 15))
            --CHANGE BULLET RAIDUS HERE
            end
            UpdateBullets(dt, cannon[i].bullets, plat, cannon[i].position)
        end 
    end
end

function DrawCannon(cannon)
    for i = 1, #cannon, 1 do
        --love.graphics.setColor(0.972, 0.533, 0.086)
        Drawbullets(cannon[i].bullets)
        --love.graphics.rectangle("fill", cannon[i].position.x, cannon[i].position.y, cannon[i].size.x, cannon[i].size.y)
        love.graphics.draw(cannon[i].spritesheet,cannon[i].spritesheetquads[cannon[i].animationframe],cannon[i].position.x,cannon[i].position.y,0,0.4)
        
        --love.graphics.setColor(1, 1, 1)
    end

end
