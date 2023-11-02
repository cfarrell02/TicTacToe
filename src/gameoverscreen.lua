local class = require("pl.class")

local GameOverScreen = class.GameOverScreen()

function GameOverScreen:_init()
    self.titleText = LABELS:getLabel("Game_Over_Text")
    self.subtitleText = LABELS:getLabel("Game_Over_Subtitle_Text")
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
    DrawText(self.titleText, WINDOWDIMENSIONS[1] / 10, WINDOWDIMENSIONS[1] / 2, WINDOWDIMENSIONS[2] / 2 - 100, WINDOWDIMENSIONS[1] * 0.5)
    DrawText(self.subtitleText, WINDOWDIMENSIONS[1] / 20, WINDOWDIMENSIONS[1] / 2, WINDOWDIMENSIONS[2] / 2 + 50, WINDOWDIMENSIONS[1] * 0.5)
end

function GameOverScreen:update(dt)
    if GAMESTATE == "gameover" then
        if love.keyboard.isDown("return") then
            self:hide()
        end
    end
end

return GameOverScreen