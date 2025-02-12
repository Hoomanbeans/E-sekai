require "player"
local buttons = {}
local font =nil
local r = 0.5
local g = 0.5
local b = 0.5
local phone = {image =nil,position=vector2.new(0,140),scale=vector2.new(0,0)}
local Start= false-- main menu
local pause = false -- pause menu
local menucd = 0.5
local background = {}
local backgroundframe = 1
local alpha = 1



function LoadMenu(player)
 local playerpos_debug = GetPlayerPosition()

 for i = 1, 4, 1 do

    background[i] = love.graphics.newImage("Assets/menu/phone/menu" .. i .. ".png")

end

font = love.graphics.newFont(32)
phone.image= love.graphics.newImage("Assets/menu/phone/phone_finalVersion.png")
phone.position.x = playerpos_debug.x + 800
phone.position.y = playerpos_debug.y - 250
phone.scale =vector2.new(0.75,0.75)

buttons[1]=newButton(500,210,250,80,"Start Game",function ()Start = true end)
buttons[2]=newButton(500,320,250,80,"Quit",   function () love.event.quit(0) end)
buttons[3]=newButton( phone.position.x+40,phone.position.y +80,200,50,"Continue Game",function ()pause = false end)
buttons[4]=newButton( phone.position.x+40,phone.position.y +150,200,50,"Quit",   function () love.event.quit(0) end)


end

function newButton(x,y,w,h,text,fn)
    return{position = vector2.new(x,y),size=vector2.new(w,h),text= text,TextP = vector2.new(x,y),fn = fn, now = false , last = false }
end

function updateMenu(dt)
    menucd = menucd -dt    
        if love.keyboard.isDown("escape") and menucd <= 0 then 
            pause = true 
            menucd = 0.5
        end
        alpha = alpha -(dt/6)
        if alpha <= 0.05 then
          
            backgroundframe = backgroundframe +1
            alpha = 1
            if backgroundframe > 4 then
                backgroundframe = 1
            end
        end

        
      
end

function DrawMenu()

 love.graphics.setColor(1, 1, 1,alpha)
    
    love.graphics.draw(background[backgroundframe],phone.position.x-400,phone.position.y-120)
    for i = 1, 2, 1 do
        
        local mx,my = love.mouse.getPosition()
        local collisiondirection = GetBoxCollisionDirection(buttons[i].position.x,buttons[i].position.y ,
                                                            buttons[i].size.x,buttons[i].size.y,mx,my,20,20)
 
                if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
                    r=0.8
                    g=0.8
                    b=0.9
                     if love.mouse.isDown(1) then 
                     buttons[i].fn()
                     end
                else
                    r=0.5
                    g=0.5
                    b=0.5
                end

        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", buttons[i].position.x, buttons[i].position.y, buttons[i].size.x, buttons[i].size.y)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(buttons[i].text,font,buttons[i].position.x+35+ (i-1)*50, buttons[i].position.y+20)
        love.graphics.setColor(1,1,1)

    end

end


function PauseDraw()
    
    font = love.graphics.newFont(24)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(phone.image,phone.position.x,phone.position.y,0,phone.scale.x,phone.scale.y)
        for i = 3, 4, 1 do
        
        local mx,my = love.mouse.getPosition()
                 Buttondirection = GetBoxCollisionDirection(buttons[i].position.x+230,buttons[i].position.y ,
                                                            buttons[i].size.x+25,buttons[i].size.y,mx,my,20,20)
 
                if Buttondirection.x ~= 0 or Buttondirection.y ~= 0 then
                    r=0.8
                    g=0.8
                    b=0.9
                     if love.mouse.isDown(1) then 
                     buttons[i].fn()
                     end
                else
                    r=0.403
                    g=0.396
                    b=0.407
                end

      
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", buttons[i].position.x-10, buttons[i].position.y, buttons[i].size.x+10, buttons[i].size.y)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(buttons[i].text,font,buttons[i].position.x+(i-3)*60, buttons[i].position.y+10)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", buttons[i].position.x-10, buttons[i].position.y, buttons[i].size.x+10, buttons[i].size.y)

    end
end
function returnStart()
    return Start
end
function returnPause()
    return pause
end