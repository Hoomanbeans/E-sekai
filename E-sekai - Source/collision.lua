function GetBoxCollisionDirection(x1, y1, w1, h1, x2, y2, w2, h2)
    local xdist = math.abs((x1 + (w1 / 2)) - (x2 + (w2 / 2)))
    local ydist = math.abs((y1 + (h1 / 2)) - (y2 + (h2 / 2)))
    local combinedwidth = (w1 / 2) + (w2 / 2)
    local combinedheight = (h1 / 2) + (h2 / 2)
    if (xdist > combinedwidth) then
        return vector2.new(0, 0)
    end
    if (ydist > combinedheight) then
        return vector2.new(0, 0)
    end
    local overlapx = math.abs(xdist - combinedwidth)
    local overlapy = math.abs(ydist - combinedheight)
    local direction = vector2.norm(vector2.sub(vector2.new(x1 + (w1 / 2), y1 + (h1 / 2)),
        vector2.new(x2 + (w2 / 2), y2 + (h2 / 2))))
    local colisiondirection
    if overlapx > overlapy then
        colisiondirection = vector2.new(0, direction.y * overlapy)
    elseif overlapx < overlapy then
        colisiondirection = vector2.new(direction.x * overlapx, 0)
    else
        colisiondirection = vector2.new(direction.x * overlapx, direction.y * overlapy)
    end
    return colisiondirection
end

function GetTilePosition(obx, oby, world, layer, object, screenoffsetx, screenoffsety)
    local x, y = world:convertPixelToTile(obx, oby)
    x = math.floor(x)
    y = math.floor(y)
    if x > 0 and x <= world.layers[layer].width and y > 0 and y <= world.layers[layer].height then
        local tile = world.layers[layer].data[y][x] 
        if tile then
            if tile.properties then
            local tx, ty = world:getLayerTilePosition(layer, tile, x, y)
            return {position = vector2.new(tx - screenoffsetx, ty - screenoffsety),
                    size = vector2.new(world.tilewidth, world.tileheight),
                    props = tile.properties
                    }
            end
        end
    end
    return nil
end

function GetNearbyTiles(world, layer, object, screenoffsetx, screenoffsety)
    local tiles = {}
    --down 1
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth,
                                object.position.y + screenoffsety + world.tileheight + object.size.y,
                                world, layer, object, screenoffsetx, screenoffsety)
    if tile then
        table.insert(tiles, tile)
    end
    --down 2
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth + object.size.x,
                                object.position.y + screenoffsety + world.tileheight + object.size.y,
                                world, layer, object, screenoffsetx, screenoffsety)
    if tile then
        table.insert(tiles, tile)    
    end

    --down 3
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth + object.size.x*0.5,
                                object.position.y + screenoffsety + world.tileheight + object.size.y,
                                world, layer, object, screenoffsetx, screenoffsety)
    if tile then
        table.insert(tiles, tile)    
    end

    --up 1
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth,
                                object.position.y + screenoffsety + world.tileheight,
                                world, layer, object, screenoffsetx, screenoffsety)
    if tile then
        table.insert(tiles, tile)    
    end
    --up 2
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth + object.size.x,
                                object.position.y + screenoffsety + world.tileheight,
                                world, layer, object, screenoffsetx, screenoffsety) 
    if tile then
        table.insert(tiles, tile)    
    end
    
    --up 2
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth + object.size.x*0.5,
                                object.position.y + screenoffsety + world.tileheight,
                                world, layer, object, screenoffsetx, screenoffsety) 
    if tile then
        table.insert(tiles, tile)    
    end  

    -- right && left 
    local tile = GetTilePosition(object.position.x + screenoffsetx + world.tilewidth + object.size.x ,
                                object.position.y + screenoffsety + world.tileheight,
                                world, layer, object, screenoffsetx, screenoffsety) 
    if tile then
        table.insert(tiles, tile)    
    end

    return tiles
end