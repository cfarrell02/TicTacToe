local class = require("pl.class")

local Splashscreen = class.Splashscreen()

function Splashscreen:_init()
    self.titleText = "Tic Tac Toe"
    self.gameStarted = false
    self.animationTimer = 0
    self.blinkDuration = 1
    self.showText = true
    self.font = love.graphics.newFont(50)
    self.titleX = (windowDimensions[1] - self.font:getWidth(self.titleText)) / 2
    self.titleY = (windowDimensions[2] - self.font:getHeight()) / 2 - 50
end

function Splashscreen:draw()
    if self.gameStarted then
        return
    end


    love.graphics.setColor(1, 1, 1)

    -- Display the title with a blinking effect
    if self.showText then
        love.graphics.setFont(self.font)
        love.graphics.print(self.titleText, self.titleX, self.titleY)
    end

    -- Display "Press space to start" message
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print("Press space to start", windowDimensions[1] / 2 - 120, windowDimensions[2] / 2 + 50)
end

function Splashscreen:update(dt)
    if love.keyboard.isDown("space") then
        self.gameStarted = true
    end

    -- Blinking for the title text
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.blinkDuration then
        self.animationTimer = self.animationTimer - self.blinkDuration
        self.showText = not self.showText
    end
end


return Splashscreen
