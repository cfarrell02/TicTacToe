local class = require("pl.class")

local Button = class.Button()

function Button:_init(x, y, w, h, text, font, color, hoverColor, clickColor, onClick)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.text = text
    self.font = font
    self.color = color
    self.hoverColor = hoverColor
    self.clickColor = clickColor
    self.onClick = onClick
    self.state = 'normal'
end

function Button:draw()
    love.graphics.setFont(self.font)
    if self.state == 'normal' then
        love.graphics.setColor(self.color)
    elseif self.state == 'hover' then
        love.graphics.setColor(self.hoverColor)
    elseif self.state == 'click' then
        love.graphics.setColor(self.clickColor)
    end
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, 10, 10)
    love.graphics.setColor(1, 1, 1)
    DrawText(self.text, self.font:getHeight(), self.x + self.w / 2 , self.y + self.h / 2, self.w - 20)
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        if love.mouse.isDown(1) then
            self.state = 'click'
        else
            self.state = 'hover'
        end
    else
        self.state = 'normal'
    end
end

function Button:mousepressed(x, y, button)
    if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
        self.onClick()
    end
end

return Button