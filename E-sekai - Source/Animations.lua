
function Create_spritesheet_quads(spritesheet,cols,rows,w,h)
    local quads = {}
    local count = 1
        --first for loop
        for j = 0, rows-1 , 1 do
            for i = 0, cols - 1, 1 do
                quads[count] = love.graphics.newQuad(i*w,j*h,w,h,spritesheet:getWidth(),spritesheet:getHeight())
                count = count+1
            end
        end
        --first for loop
    return quads
end

function Load_ssheet(player,slime,cannon,king,shield)
 
    local slime_sprite = love.graphics.newImage("Assets//Enemies//animation_slime//Slime2.png")
    local slime_quads =  Create_spritesheet_quads(slime_sprite,4,4,32,32)

    for i = 1 , #slime , 1 do
        
        slime[i].spritesheet = slime_sprite
        slime[i].spritesheetquads = slime_quads

    end

    local player_sprite = love.graphics.newImage("Assets//Player//Running_animation2.png")
    local player_quads = Create_spritesheet_quads(player_sprite,11,4,40,56)
        
        player.spritesheet = player_sprite
        player.spritesheetquads = player_quads

    local cannon_sprite = love.graphics.newImage("Assets/cannon/cannon_sprites.png")
    local cannon_quads = Create_spritesheet_quads(player_sprite,4,2,32,32)

    for i = 1 , #cannon , 1 do
        
        cannon[i].spritesheet = cannon_sprite
        cannon[i].spritesheetquads = cannon_quads

    end

    local shield_sprite = love.graphics.newImage("Assets/Enemies/animation_shield/shild_animationst.png")
    local shield_quads = Create_spritesheet_quads(player_sprite,13,4,38,55)

    for i = 1 , #shield , 1 do
        
        shield[i].spritesheet = shield_sprite
        shield[i].spritesheetquads = shield_quads

    end

  

end