-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModTheme = class.ModTheme()

function ModTheme:_init(game, splashScreen, label)
    self.game = game
    self.splashScreen = splashScreen
    self.modType = "theme"
end


function ModTheme:run()
    self.game:setTheme("dark")
end

function ModTheme:remove()
    self.game:setTheme("light")
end

return ModTheme