-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModEngine = class.ModEngine()

function ModEngine:_init(game)
    -- print(game)
    self.game = game
end

function ModEngine:applyMods()
    -- TODO: load all mods without having to modify this method
    local ModPlayerIcons = require "src/modPlayerIcons"
    local mod = ModPlayerIcons(self.game)
    mod:run()
end

return ModEngine