vector2 = {}

function vector2.new(px, py)
    
    return {x = px, y = py}

end

function vector2.add(vec1, vec2)
    
    local result = vector2.new(0, 0)
    
    result.x = vec1.x + vec2.x
    result.y = vec1.y + vec2.y
    
    return result
end

function vector2.sub(vec1, vec2)
    
    local result = vector2.new(0, 0)
    
    result.x = vec1.x - vec2.x
    result.y = vec1.y - vec2.y
    
    return result
end

function vector2.mult(vec1, const)
    
    local result = vector2.new(vec1.x, vec1.y)
    
    result.x = vec1.x * const
    result.y = vec1.y * const
    
    return result
end

function vector2.div(vec1, const)
    
    local result = vector2.new(vec1.x, vec1.y)
    
    result.x = vec1.x / const
    result.y = vec1.y / const
    
    return result
end

function vector2.magni(vec1)
    return math.sqrt(vec1.x * vec1.x + vec1.y * vec1.y)
end

function vector2.norm(vec1)
    
    local mag = vector2.magni(vec1)
    
    if mag ~= 0 then
        return vector2.div(vec1, mag)
    end
    return vec1
end

function vector2.limit(vec1, max)
    
    local mag = vector2.magni(vec1)
    
    if mag > max then
        local result = vector2.norm(vec1)
        return vector2.mult(result, max)
    end
    return vec1
end

function vector2.applyforce(force, mass, accel)
    local f = vector2.div(force, mass)
    return vector2.add(accel, f)
end

function vector2.checkcollision(player_pos, player_size, box_pos, box_size)
    
    return (player_pos.x < box_pos.x + box_size.x and box_pos.x < player_pos.x + player_size.x
        and player_pos.y < box_pos.y + box_size.y and box_pos.y < player_pos.y + player_size.y)

end

--new stuff dont know what it does 
function vector2.dot(vec1, vec2)
    return (vec1.x * vec2.x) + (vec1.y * vec2.y)
end
