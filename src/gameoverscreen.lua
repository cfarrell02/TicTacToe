local class = require("pl.class")

local GameOverScreen = class.GameOverScreen()

function GameOverScreen:_init()
    self.titleText = "Game Over"
    self.subtitleText = "Press Enter to play again"
    self.isShown = false
end

function GameOverScreen:show(text)
    self.titleText = text
    self.isShown = true
end

function GameOverScreen:hide()
    self.isShown = false
end


function GameOverScreen:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(windowDimensions[1] / 10))
    love.graphics.print(self.titleText, windowDimensions[1] / 2 - windowDimensions[1] * 0.15, windowDimensions[2] / 2 - 100)
    love.graphics.setFont(love.graphics.newFont(windowDimensions[1] / 20))
    love.graphics.print(self.subtitleText, windowDimensions[1] / 2 - windowDimensions[1] * 0.3, windowDimensions[2] / 2 )
end

function GameOverScreen:update(dt)
    if self.isShown then
        if love.keyboard.isDown("return") then
            self:hide()
        end
    end
end

return GameOverScreen