-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModBackgroundEffect = class.ModBackgroundEffect()

function ModBackgroundEffect:_init(game, splashScreen, gameOverScreen)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
    self.delay = 1
    self.func = function()
        local r = math.random(0, 255) / 255
        local g = math.random(0, 255) / 255
        local b = math.random(0, 255) / 255
        -- Add a delay to the background color change
        if self.delay > 0 then
            self.delay = self.delay - love.timer.getDelta()
            return
        end
        self.delay = 1
        love.graphics.setBackgroundColor(r, g, b)
    end
end

function ModBackgroundEffect:run()
    --self.game:registerModDrawFunction(self.func)
end

function ModBackgroundEffect:remove()
    --self.game:unregisterModDrawFunction(self.func)
    self.game:clearModDrawFunctions()

end

return ModBackgroundEffect