local class = require("pl.class")

local Splashscreen = class.Splashscreen()

function Splashscreen:_init()
    self.titleText = "Tic Tac Toe"
    self.gameStarted = false
    self.animationTimer = 0
    self.blinkDuration = 1
    self.showText = true
    self.font = love.graphics.newFont(windowDimensions[1] / 10)
    self.titleX = (windowDimensions[1] - self.font:getWidth(self.titleText)) / 2
    self.titleY = (windowDimensions[2] - self.font:getHeight()) / 2 - 50

    -- Create background Xs and Os
    self.backgroundXs = {}
    self.backgroundOs = {}
    for i = 1, 20 do
        table.insert(self.backgroundXs, {
            x = love.math.random(0, windowDimensions[1]),
            y = love.math.random(0, windowDimensions[2]),
            speed = love.math.random(20, 50),
            size = love.math.random(5, 30),
        })
        table.insert(self.backgroundOs, {
            x = love.math.random(0, windowDimensions[1]),
            y = love.math.random(0, windowDimensions[2]),
            speed = love.math.random(20, 50),
            size = love.math.random(5, 20),
        })
    end
end

function Splashscreen:draw()
    if self.gameStarted then
        return
    end

    love.graphics.setColor(1, 1, 1)

    -- Draw Xs and Os as moving shapes in the background
    for _, x in ipairs(self.backgroundXs) do
        love.graphics.line(x.x, x.y, x.x + x.size, x.y + x.size)
        love.graphics.line(x.x, x.y + x.size, x.x + x.size, x.y)
        x.y = x.y + x.speed * love.timer.getDelta()
        if x.y > windowDimensions[2] + x.size then
            x.y = -x.size
            x.x = love.math.random(0, windowDimensions[1])
        end
    end

    for _, o in ipairs(self.backgroundOs) do
        love.graphics.circle("line", o.x, o.y, o.size)
        o.y = o.y + o.speed * love.timer.getDelta()
        if o.y > windowDimensions[2] + o.size then
            o.y = -o.size
            o.x = love.math.random(0, windowDimensions[1])
        end
    end

    -- Draw the title text    
        love.graphics.setFont(self.font)
        love.graphics.print(self.titleText, self.titleX, self.titleY)
    
    --Blinking start text
    if self.showText then
    love.graphics.setFont(love.graphics.newFont(windowDimensions[1] / 20))
    love.graphics.print("Press space to start", windowDimensions[1] / 2 - windowDimensions[1] * 0.25, windowDimensions[2] / 2 + 50)
    end
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
