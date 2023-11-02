-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModPlayerIcons = class.ModPlayerIcons()

function ModPlayerIcons:_init(game, splashScreen, label)
    self.game = game
    self.splashScreen = splashScreen
    self.modType = "icon"

end

function ModPlayerIcons:run()
    self.game:setPlayerIcons("Cpt'n X", "Ol' Salty O")
end

function ModPlayerIcons:remove()
    self.game:setPlayerIcons("X", "O")
end

return ModPlayerIcons