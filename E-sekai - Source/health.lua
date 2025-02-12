
local S_heart = love.graphics.newImage("Assets/UI/Heart_Sprite.png")

function CheckHealth(int, player, st_point)
    
    if int <= 0 then
        player.position.y = st_point.y
        player.position.x = st_point.x
        player.Palpha = 1
        player.hp = 3
        player.invincibilityS = 0.5
        local sound = Get_sound()
        Play_audio(sound,"player_death",100,100,false)
        reset()
    else
        end
end

function Createlife(int, camera)
    local S_heart = love.graphics.newImage("Assets/UI/Heart_Sprite.png")
    local x_incre = 0
    for i = 1, int, 1 do
        --love.graphics.rectangle("fill", (camera.posx+25) + x_incre,(camera.posy+25) , 50, 50)
        love.graphics.draw(S_heart ,(camera.posx+25) + x_incre,(camera.posy+25) , 0,1.5 )
        x_incre = x_incre + 60
    end

end

