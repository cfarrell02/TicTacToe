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
local boardWidth = 3
local padding = 50
local tileWidth = 200
local screenText = ""
local scoreText = ""
local winner = nil

--Global variables
WINDOWDIMENSIONS = { boardWidth * tileWidth + 100, boardWidth * tileWidth + 150 }
GAMESTATE = "splashscreen"
GAMEMODE = "Singleplayer"


local gameOverTimer = 0
local gameOverDelay = 1 -- Adjust this value to set the delay in seconds

-- Initialize game-related objects
local game = TicTacToe(boardWidth)
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
    splashscreen:update(dt)
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
        
        if button == 1 then
            local row = math.floor((y - padding) / tileWidth) + 1
            local col = math.floor((x - padding) / tileWidth) + 1

            if row and col and row >= 1 and row <= boardWidth and col >= 1 and col <= boardWidth then

                if game:makeMove(row, col) then
                    eventHandler:raise("move", { col = col, row = row, valid = true })
                    screenText = string.format("Player %s's turn", game.currentPlayer)
                    winner = game:checkWin()
                else
                    screenText = "Invalid move!"
                    eventHandler:raise("move", { col = col, row = row, valid = false })
                end
            else
                screenText = "Invalid move!"
            end
        end
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

