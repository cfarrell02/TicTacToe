-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModTheme = class.ModTheme()

function ModTheme:_init(game, splashScreen, gameOverScreen)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
end


function ModTheme:run()
    self.game:setTheme("dark")
end

return ModTheme