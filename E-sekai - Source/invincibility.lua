function invincibility(dt, player)
    
    if player.invincibilityS >= player.invincibilityO then
        player.hp = player.hp - 1
        player.invincibilityS = 0
    end
end

function ChangeVisual(dt, player)
    if player.changeAlpha == true then
        player.alphaStart = player.alphaStart + dt
        if player.alphaStart >= player.alphaTimer then
            player.Palpha = 1
            player.alphaStart = 0
            player.changeAlpha = false
        end
    end
end
