local Font_n_plataforma = love.graphics.newFont(20)
local Font_default = love.graphics.newFont(12)
local heart = love.graphics.newImage("Assets/UI/Heart_Sprite.png")

function CreatePlatform(x, y, w, h, color)
    return {position = vector2.new(x, y), size = vector2.new(w, h), type = color}
end

function Health_up(x, y)
    return {position = vector2.new(x, y), size = vector2.new(50, 50), type = "health_up"}
end

function next_level(x, y)
    return {position = vector2.new(x, y), size = vector2.new(50, 300), type = "level+1"}
end

function DrawPlatforms(world)
    for i = 1, #world, 1 do
        if world[i].type == "g_grass" then
            --love.graphics.setColor(0, 1, 0)
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            --love.graphics.setColor(0, 0, 0)
        elseif world[i].type == "death_block" then
            --love.graphics.setColor(0.443, 0.035, 0.078)
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            --love.graphics.setColor(0, 0, 0)
        elseif world[i].type == "spike" then
            --love.graphics.setColor(0.560, 0.560, 0.560)
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            --love.graphics.setColor(0, 0, 0)
        elseif world[i].type == "health_up" then
            
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            love.graphics.draw(heart,world[i].position.x, world[i].position.y,0,1)
           
        elseif world[i].type == "level+1" then
            --love.graphics.setColor(1, 1, 1)
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            --love.graphics.setColor(0, 0, 0)
        elseif world[i].type == "g_boss" then
            --love.graphics.setColor(0.549, 0.282, 0.129)
            --love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
            --love.graphics.setColor(0, 0, 0)
        end
        if show_plat_number == true then
            --server para ver qual o numera da platforma para depois mudar no main.lua
            --love.graphics.setColor(0, 0, 0)
            --love.graphics.setFont(Font_n_plataforma)
            --love.graphics.print(i, world[i].position.x + (world[i].size.x / 2)-10, world[i].position.y + (world[i].size.y / 2)-10)
            --love.graphics.setFont(Font_default)
            --love.graphics.setColor(1, 1, 1)
        --server para ver qual o numera da platforma para depois mudar no main.lua
        else
            end
    end
end
