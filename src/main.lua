-- main.lua

-- Modify package.path to include your custom directory
package.path = package.path .. ";/opt/homebrew/Cellar/luarocks/3.9.2/share/lua/5.4/?.lua"

-- Load required modules
local TicTacToe = require("game")
local EventHandler = require("eventHandler")
local Splashscreen = require("splashscreen")
local GameOverScreen = require("gameoverscreen")
local socket = require('socket')

-- Game properties
local padding = 50
local tileWidth = 200
local screenText = ""
local scoreText = ""
local winner = nil

--Global variables
BOARDWIDTH = 3
WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
GAMESTATE = "splashscreen"
GAMEMODE = "Singleplayer"


local gameOverTimer = 0
local gameOverDelay = 1 -- Adjust this value to set the delay in seconds

-- Initialize game-related objects
local game = TicTacToe(BOARDWIDTH)
local eventHandler = EventHandler()
local splashscreen = Splashscreen()
local gameOverScreen = GameOverScreen()

-- Love.load function
function love.load(args)
    love.window.setTitle("Tic Tac Toe")
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    love.graphics.setBackgroundColor(0.208, 0.6, 0.941)
    scoreText = string.format("X: %d | O: %d", game.score['X'], game.score['O'])
    screenText = string.format("Player %s's turn", game.currentPlayer)

    
end

-- Love.update function
function love.update(dt)
    if GAMESTATE == "splashscreen" then
        splashscreen:update(dt)
        return
    end
    game:update(dt)

    if love.keyboard.isDown("escape") then
        GAMESTATE = "splashscreen"
        game:resetScores()
        game:reset()
        scoreText = string.format("X: %d | O: %d", game.score['X'], game.score['O'])
        screenText = string.format("Player %s's turn", game.currentPlayer)
    end

    if GAMESTATE == "playing" then
            updateGame(dt)
        else if GAMESTATE == "gameover" then
            gameOverScreen:update(dt)
        end
    end
    
end

-- Love.draw function
function love.draw()
    if GAMESTATE == "splashscreen" then
        splashscreen:draw()
        return
    end

        -- Draw the game board and elements
        if GAMESTATE == "gameover"  then
            gameOverScreen:draw()
            return
        else
            game:draw(padding, tileWidth)
        end
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.print(screenText, WINDOWDIMENSIONS[1] / 2 - string.len(screenText) * 6, WINDOWDIMENSIONS[2] - 50)

        -- Draw the score
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.print(scoreText, WINDOWDIMENSIONS[1] / 2 - string.len(scoreText) * 4, 10)




end

-- Mouse click
function love.mousepressed(x, y, button, istouch, presses)
    
    if GAMESTATE == "playing" then
        game:mousepressed(x, y, button)
        
        if button == 1 then
            local row = math.floor((y - padding) / tileWidth) + 1
            local col = math.floor((x - padding) / tileWidth) + 1

            if row and col and row >= 1 and row <= BOARDWIDTH and col >= 1 and col <= BOARDWIDTH then

                if game:makeMove(row, col) then
                    eventHandler:raise("move", { col = col, row = row, valid = true })
                    screenText = string.format("Player %s's turn", game.currentPlayer)
                    winner = game:checkWin()
                else
                    eventHandler:raise("move", { col = col, row = row, valid = false })
                end
            else
            end
        end
    elseif GAMESTATE == "splashscreen" then
        splashscreen:mousepressed(x, y, button)
    end
end



-- Update game state
function updateGame(dt)

    winner = game:checkWin()

    if winner then
        screenText = winner .. " wins!"
        gameOverTimer = gameOverTimer + dt
        if gameOverTimer >= gameOverDelay then
            gameOverTimer = 0
            gameOverScreen:show(winner .. " wins!")
            eventHandler:raise("win", { winner = winner })
            game:incrementScore(winner)
            game:reset()
            scoreText = string.format("X: %d | O: %d", game.score['X'], game.score['O'])
            screenText = "Tic Tac Toe"
        end

    elseif game:isFull() then
        screenText = "Draw!"
        gameOverTimer = gameOverTimer + dt
        if gameOverTimer >= gameOverDelay then
            gameOverTimer = 0
            gameOverScreen:show("Draw!")
            eventHandler:raise("draw")
            game:reset()
            screenText = "Tic Tac Toe"
        end
    end
end

function highlightBox(x, y, width, height, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 1, 1)
end

--Global function for resetting game width
RESETGAMEWIDTH = function(width)
    BOARDWIDTH = width
    WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    game = TicTacToe(BOARDWIDTH)
    splashscreen = Splashscreen()
end

SETSCREENTEXT = function(text)
    screenText = text
end


SAVEGAME = function ()
    local file = io.open("savegame.txt", "w")
    file:write(BOARDWIDTH .. "\n")
    file:write(GAMEMODE .. "\n")
    file:write(game.score['X'] .. "\n")
    file:write(game.score['O'] .. "\n")
    file:write(game.currentPlayer .. "\n")
    file:write(game.board .. "\n")
    file:close()
end

LOADGAME = function ()
    local file = io.open("savegame.txt", "r")
    if file then
        BOARDWIDTH = tonumber(file:read())
        WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
        love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
        game = TicTacToe(BOARDWIDTH)
        GAMEMODE = file:read()
        game.score['X'] = tonumber(file:read())
        game.score['O'] = tonumber(file:read())
        game.currentPlayer = file:read()
        game.board = file:read()
        file:close()
        scoreText = string.format("X: %d | O: %d", game.score['X'], game.score['O'])
        screenText = string.format("Player %s's turn", game.currentPlayer)
    end
end