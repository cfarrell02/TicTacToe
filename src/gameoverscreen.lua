local class = require("pl.class")

local GameOverScreen = class.GameOverScreen()

function GameOverScreen:_init()
    self.titleText = "Game Over"
    self.subtitleText = "Press Enter to play again"
end

function GameOverScreen:show(text)
    self.titleText = text
    GAMESTATE = "gameover"
end

function GameOverScreen:hide()
    GAMESTATE = "playing"
end


function GameOverScreen:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(WINDOWDIMENSIONS[1] / 10))
    love.graphics.print(self.titleText, WINDOWDIMENSIONS[1] / 2 - WINDOWDIMENSIONS[1] * 0.15, WINDOWDIMENSIONS[2] / 2 - 100)
    love.graphics.setFont(love.graphics.newFont(WINDOWDIMENSIONS[1] / 20))
    love.graphics.print(self.subtitleText, WINDOWDIMENSIONS[1] / 2 - WINDOWDIMENSIONS[1] * 0.3, WINDOWDIMENSIONS[2] / 2 )
end

function GameOverScreen:update(dt)
    if GAMESTATE == "gameover" then
        if love.keyboard.isDown("return") then
            self:hide()
        end
    end
end

return GameOverScreen