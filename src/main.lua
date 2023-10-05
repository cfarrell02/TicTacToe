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
local screenText = "Tic Tac Toe"
local winner = nil
windowDimensions = { boardWidth * tileWidth + 100, boardWidth * tileWidth + 150 }


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
    love.window.setMode(windowDimensions[1], windowDimensions[2], { resizable = false, vsync = false })
    love.graphics.setBackgroundColor(0.208, 0.6, 0.941)
end

-- Love.update function
function love.update(dt)
    splashscreen:update(dt)

    if love.keyboard.isDown("escape") then
        splashscreen.gameStarted = false
    end

    if splashscreen.gameStarted then
        gameOverScreen:update(dt)
        updateGame(dt)
    end
end

-- Love.draw function
function love.draw()
    splashscreen:draw()

    if splashscreen.gameStarted then
        -- Draw the game board and elements
        if gameOverScreen.isShown then
            gameOverScreen:draw()
        else
            drawGame()
        end
        local fontSize = 20
        love.graphics.setFont(love.graphics.newFont(fontSize))
        love.graphics.print(screenText, windowDimensions[1] / 2 - string.len(screenText) * fontSize * 0.3, windowDimensions[2] - 50)
    end
end

-- Mouse click
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and splashscreen.gameStarted then
        local row = math.floor((y - padding) / tileWidth) + 1
        local col = math.floor((x - padding) / tileWidth) + 1

        if row and col and row >= 1 and row <= boardWidth and col >= 1 and col <= boardWidth then
            if game:makeMove(row, col) then
                eventHandler:raise("move", { col = col, row = row, valid = true })
                winner = game:checkWin()
            else
                print("Invalid move. Try again.")
                eventHandler:raise("move", { col = col, row = row, valid = false })
            end
        else
            print("Invalid input. Please enter valid row and column numbers (1-3).")
        end
    end
end

-- Draw the game board and elements
function drawGame()
    -- Drawing the board grid
    for i = 1, boardWidth - 1 do
        for j = 1, boardWidth - 1 do
            love.graphics.line(padding + i * tileWidth, padding, padding + i * tileWidth, padding + tileWidth * boardWidth)
            love.graphics.line(padding, padding + j * tileWidth, padding + tileWidth * boardWidth, padding + j * tileWidth)
        end
    end

    -- Drawing the X's and O's
    local board = game.board

    for i = 1, boardWidth do
        for j = 1, boardWidth do
            if board[i] and board[i][j] then
                if board[i][j] == "X" then
                    love.graphics.line(padding + (j - 1) * tileWidth + 10, padding + (i - 1) * tileWidth + 10, padding + j * tileWidth - 10, padding + i * tileWidth - 10)
                    love.graphics.line(padding + (j - 1) * tileWidth + 10, padding + i * tileWidth - 10, padding + j * tileWidth - 10, padding + (i - 1) * tileWidth + 10)
                elseif board[i][j] == "O" then
                    love.graphics.circle("line", padding + (j - 1) * tileWidth + tileWidth / 2, padding + (i - 1) * tileWidth + tileWidth / 2, tileWidth / 2 - 10)
                end
            end
        end
    end
end

-- Update game state
function updateGame(dt)
    winner = game:checkWin()

    if winner then
        gameOverTimer = gameOverTimer + dt
        if gameOverTimer >= gameOverDelay then
            gameOverTimer = 0
            gameOverScreen:show(winner .. " wins!")
            game:reset()
        end

    elseif game:isFull() then
        gameOverTimer = gameOverTimer + dt
        if gameOverTimer >= gameOverDelay then
            gameOverTimer = 0
            gameOverScreen:show("Draw!")
            game:reset()
        end
    end
end

