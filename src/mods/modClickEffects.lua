-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModClickEffect = class.ModClickEffect()

function ModClickEffect:_init(game, splashScreen, gameOverScreen, label)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
    self.modType = "clickEffect"
    self.func =  function()
        local x = love.mouse.getX()
        local y = love.mouse.getY()
        -- Hide the cursor
        love.mouse.setVisible(false)

        self:drawFunCursor(x, y)
        
    end
end

function ModClickEffect:run()
    self.game:registerModDrawFunction(self.func)
end


function ModClickEffect:drawFunCursor(x,y) 
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', x, y, 10, 10, 10, 10)
end

function ModClickEffect:remove()
    --self.game:unregisterModDrawFunction(self.func)
    self.game:clearModDrawFunctions()
    love.mouse.setVisible(true)
end

return ModClickEffect