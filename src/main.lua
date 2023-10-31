-- main.lua

-- Modify package.path to include your custom directory
package.path = package.path .. ";/opt/homebrew/Cellar/luarocks/3.9.2/share/lua/5.4/?.lua"

-- Load required modules
local TicTacToe = require("game")
local EventHandler = require("eventHandler")
local Splashscreen = require("splashscreen")
local GameOverScreen = require("gameoverscreen")
local ModEngine = require("modEngine")
local socket = require('socket')

-- Game properties
local padding = 50
local tileWidth = 200
local screenText = ""
local scoreText = ""

--Global variables
BOARDWIDTH = 3
WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
GAMESTATE = "splashscreen"
GAMEMODE = "Singleplayer"


-- Initialize game-related objects
local game = TicTacToe(BOARDWIDTH)
local eventHandler = EventHandler()
local splashscreen = Splashscreen()
local gameOverScreen = GameOverScreen()
local modEngine = ModEngine(game, splashscreen, gameOverScreen)

-- Love.load function
function love.load(args)
    modEngine:applyMods()
    love.window.setTitle("Tic Tac Toe")
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    love.graphics.setBackgroundColor(game.backgroundColor)
    SetScoreText(string.format("%s: %d | %s: %d", game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))
    screenText = string.format("Player %s's turn", game.currentPlayer)
    
end




-- Love.update function
function love.update(dt)
    if GAMESTATE == "splashscreen" then
        splashscreen:update(dt)
        return
    end

    if love.keyboard.isDown("escape") then
        GAMESTATE = "splashscreen"
        game:resetScores()
        game:reset()
        SetScoreText(string.format("%s: %d | %s: %d", game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))
        screenText = string.format("Player %s's turn", game.currentPlayer)
    end

    if GAMESTATE == "playing" then
            game:update(dt)
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





--Global function for resetting game width
function ResetGameWidth(width)
    BOARDWIDTH = width
    WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    game = TicTacToe(BOARDWIDTH)
    splashscreen = Splashscreen()
end

function SetScreenText(text)
    screenText = text
end

function SetScoreText(text)
    scoreText = text
end

function HighlightBox(x, y, width, height, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 1, 1)
end

function ShowGameOverScreen(text)
    gameOverScreen:show(text)
end



-- SAVEGAME = function ()
--     local file = io.open("savegame.txt", "w")
--     file:write(BOARDWIDTH .. "\n")
--     file:write(GAMEMODE .. "\n")
--     file:write(game.score['X'] .. "\n")
--     file:write(game.score['O'] .. "\n")
--     file:write(game.currentPlayer .. "\n")
--     file:close()
-- end

-- LOADGAME = function ()
--     local file = io.open("savegame.txt", "r")
--     if file then
--         BOARDWIDTH = tonumber(file:read())
--         WINDOWDIMENSIONS = { BOARDWIDTH * tileWidth + 100, BOARDWIDTH * tileWidth + 150 }
--         love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
--         game = TicTacToe(BOARDWIDTH)
--         GAMEMODE = file:read()
--         game.score['X'] = tonumber(file:read())
--         game.score['O'] = tonumber(file:read())
--         game.currentPlayer = file:read()
--         file:close()
--         scoreText = string.format("X: %d | O: %d", game.score['X'], game.score['O'])
--         screenText = string.format("Player %s's turn", game.currentPlayer)
--     end
-- end