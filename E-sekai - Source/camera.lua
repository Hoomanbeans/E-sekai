
local camera = {
  posx = 0,
  posy = 0,
  scaleX = 1,
  scaleY = 1,
  rotation = 0,
  bounds = {}
}


function Cam_set(cam,world,player)
  love.graphics.push()
  love.graphics.rotate(-cam.rotation)
  love.graphics.scale(cam.scaleX,cam.scaleY)
  love.graphics.translate(-cam.posx, -cam.posy) -- this also need to be turn on
  world:draw(-cam.posx - player.off_setx, -cam.posy - player.off_sety )

end

function Cam_unset()
  love.graphics.pop()
end

function Cam_move(cam,dx, dy)
  cam.posx = cam.posx + (dx or 0)
  cam.posy = cam.posy + (dy or 0)
end

function Cam_rotate(cam,dr)
  cam.rotation = cam.rotation + dr
end

function Cam_scale(cam,sx, sy)
  sx = sx or 1
  cam.scaleX = cam.scaleX * sx
  cam.scaleY = cam.scaleY * (sy or sx)
end

function Cam_setX(cam,value)
  if cam.bounds then
    cam.posx = math.clamp(value, cam.bounds.x1, cam.bounds.x2)
  else
    cam.posx = value
  end
end

function Cam_setY(cam,value)
  if cam.bounds then
    cam.posy = math.clamp(value, cam.bounds.y1, cam.bounds.y2)
  else
    cam.posy = value
  end
end

function Cam_setPosition(cam)
  --[[
  if cam.posx then cam_setX(x) end
  if cam.posy then cam_setY(y) end
  ]]
end

function Cam_setScale(cam,sx, sy)
  cam.scaleX = sx or cam.scaleX
  cam.scaleY = sy or cam.scaleY
end

function Cam_getBounds(cam)
  return cam.bounds
end

function Cam_setBounds(cam,x1, y1, x2, y2)
  cam.bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function Get_cam()

  return camera
  
end