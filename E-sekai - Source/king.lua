

local king = {
    position = vector2.new(600, 545),
    size = vector2.new(64, 128),
    bossHp = 50,
    die = false,
    Kalpha = 1,
    color = 0,
  
}


local  Boss = love.graphics.newImage("Assets/Boss/Final_boss.png")
function Drawking(king)

    local lvl3 = GetInc()
    if  lvl3 == 3 or  lvl3 == 4 then 
        
    local x_increment = 0
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Boss, king.position.x-40, king.position.y-50,0,1.5,1.5)
   -- love.graphics.rectangle("fill", king.position.x, king.position.y, king.size.x, king.size.y)
    for i = 1, king.bossHp, 1 do
        love.graphics.setColor(0.835, 0.043, 0.062)
        love.graphics.rectangle("fill", ((king.position.x - 600) + x_increment), 700, 10, 20)
        love.graphics.setColor(1, 1, 1)
        x_increment = x_increment + 10
    end
    
    if king.bossHp <= 0 then
        king.die = true
        local Font_default = love.graphics.newFont(12)
        local Font_n_plataforma = love.graphics.newFont(50)
        love.graphics.setFont(Font_n_plataforma)
        love.graphics.print("YOU WON THE Game", king.position.x - 600, 200)
        love.graphics.setFont(Font_default)
    end
end
end

function getking()
    return king
end

function king_pos(kingo , x,y)

    kingo.position.x = x
    kingo.position.y = y

end
