-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModPlayerIcons = class.ModPlayerIcons()

function ModPlayerIcons:_init(game, splashScreen, gameOverScreen)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
end

function ModPlayerIcons:run()
    self.game:setPlayerIcons("Me", "You")
end

return ModPlayerIcons