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
    for i = 1, 10 do
        table.insert(self.backgroundXs, {
            x = love.math.random(0, windowDimensions[1]),
            y = love.math.random(0, windowDimensions[2]),
            speed = love.math.random(20, 50),
        })
        table.insert(self.backgroundOs, {
            x = love.math.random(0, windowDimensions[1]),
            y = love.math.random(0, windowDimensions[2]),
            speed = love.math.random(20, 50),
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
        love.graphics.line(x.x, x.y, x.x + 10, x.y + 10)
        love.graphics.line(x.x, x.y + 10, x.x + 10, x.y)
        x.x = x.x - x.speed * love.timer.getDelta()
        if x.x < -5 then
            x.x = windowDimensions[1] + 10
            x.y = love.math.random(0, windowDimensions[2])
        end
    end

    for _, o in ipairs(self.backgroundOs) do
        love.graphics.circle("line", o.x, o.y, 5)
        o.x = o.x - o.speed * love.timer.getDelta()
        if o.x < -5 then
            o.x = windowDimensions[1] + 10
            o.y = love.math.random(0, windowDimensions[2])
        end
    end

    -- Display the title with a blinking effect
    if self.showText then
        love.graphics.setFont(self.font)
        love.graphics.print(self.titleText, self.titleX, self.titleY)
    end

    -- Display "Press space to start" message
    love.graphics.setFont(love.graphics.newFont(windowDimensions[1] / 20))
    love.graphics.print("Press space to start", windowDimensions[1] / 2 - windowDimensions[1] * 0.25, windowDimensions[2] / 2 + 50)
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
