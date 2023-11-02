-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModEngine = class.ModEngine()

function ModEngine:_init(game, splashScreen, gameOverScreen, labels)
    -- print(game)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
    self.labels = labels
end

function ModEngine:applyMods()
    --find all mods in mods folder
    
    local inputdir = "mods"
    -- use love2d filesystem to get all files in mods folder
    local files = love.filesystem.getDirectoryItems(inputdir)
    for i, file in ipairs(files) do
         -- remove .lua
        local modname = string.sub(file, 1, -5)
        local mod = require(inputdir .. "/" .. modname)
        local moditem = mod(self.game, self.splashScreen, self.gameOverScreen, self.labels)
        if moditem.modType ~= "labels" then
            print("Activating mod: " .. modname .. " " .. moditem.modType)
            moditem:run()
        end
    end
end

function ModEngine:applyLabelMods()
    local inputdir = "mods"
    -- use love2d filesystem to get all files in mods folder
    local files = love.filesystem.getDirectoryItems(inputdir)
    for i, file in ipairs(files) do
         -- remove .lua
        local modname = string.sub(file, 1, -5)
        local mod = require(inputdir .. "/" .. modname)
        local moditem = mod(self.game, self.splashScreen, self.gameOverScreen, self.labels)
        if moditem.modType == "labels" then
            print("Activating mod: " .. modname .. " " .. moditem.modType)
            moditem:run()
        end
    end
end

function ModEngine:removeMods()
    --find all mods in mods folder
    
    local inputdir = "mods"
    -- use love2d filesystem to get all files in mods folder
    local files = love.filesystem.getDirectoryItems(inputdir)
    for i, file in ipairs(files) do
         -- remove .lua
        local modname = string.sub(file, 1, -5)
        local mod = require(inputdir .. "/" .. modname)
        local moditem = mod(self.game, self.splashScreen, self.gameOverScreen)
        moditem:remove()

    end
    
end

return ModEngine