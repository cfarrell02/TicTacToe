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

--Global variables
BOARDWIDTH = 3
GAMESTATE = "splashscreen"
GAMEMODE = "Singleplayer"
WINDOWDIMENSIONS = { BOARDWIDTH * 200 + 100, BOARDWIDTH * 200 + 150}





-- Initialize game-related objects
local game = TicTacToe(BOARDWIDTH)
local eventHandler = EventHandler()
local splashscreen = Splashscreen()
local gameOverScreen = GameOverScreen()
local modEngine = ModEngine(game, splashscreen, gameOverScreen)
local screenText = ""
local scoreText = ""



-- Love.load function
function love.load(args)
    WINDOWDIMENSIONS = { BOARDWIDTH * game.tileWidth + 100, BOARDWIDTH * game.tileWidth + 150 }
    love.window.setTitle(game.title)
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
    -- Draw the score
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print(scoreText, WINDOWDIMENSIONS[1] / 2 - string.len(scoreText) * 4, 10)
    
    if GAMESTATE == "splashscreen" then
        splashscreen:draw()
        game:drawModElements()
        return
    end

        -- Draw the game board and elements
        if GAMESTATE == "gameover"  then
            gameOverScreen:draw()
            game:drawModElements()
            return
        elseif GAMESTATE == "playing" then
            game:draw(game.padding, game.tileWidth)
        end


        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.print(screenText, WINDOWDIMENSIONS[1] / 2 - string.len(screenText) * 6, WINDOWDIMENSIONS[2] - 50)
        game:drawModElements()

end

-- Mouse click
function love.mousepressed(x, y, button, istouch, presses)
    
    if GAMESTATE == "playing" then
        game:mousepressed(x, y, button)
        
        if button == 1 then
            local row = math.floor((y - game.padding) / game.tileWidth) + 1
            local col = math.floor((x - game.padding) / game.tileWidth) + 1

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
    WINDOWDIMENSIONS = { BOARDWIDTH * game.tileWidth + 100, BOARDWIDTH * game.tileWidth + 150 }
    game = TicTacToe(BOARDWIDTH)
    splashscreen = Splashscreen()
    gameOverScreen = GameOverScreen()
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
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



function SaveScores()
    local file = io.open("scores.txt", "w")
    file:write(string.format("%s,%d\n", game.playerOne, game.score[game.playerOne]))
    file:write(string.format("%s,%d\n", game.playerTwo, game.score[game.playerTwo]))
    file:write(string.format("%d\n", BOARDWIDTH))
    file:close()
end

function LoadScores()
    local file = io.open("scores.txt", "r")
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end

        if #lines ~= 3 then
            return
        end

        -- Player 1
        game.playerOne = string.sub(lines[1], 1, string.find(lines[1], ",") - 1)
        game.score[game.playerOne] = tonumber(string.sub(lines[1], string.find(lines[1], ",") + 1))

        -- Player 2
        game.playerTwo = string.sub(lines[2], 1, string.find(lines[2], ",") - 1)
        game.score[game.playerTwo] = tonumber(string.sub(lines[2], string.find(lines[2], ",") + 1))

        SetScoreText(string.format("%s: %d | %s: %d", game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))

        -- Board width
        
        if BOARDWIDTH ~= tonumber(lines[3]) then
            ResetGameWidth(tonumber(lines[3]))
        end
    end
end


function SetMods(enabled)
    if enabled then
        -- Refresh everything
        game = TicTacToe(BOARDWIDTH)
        splashscreen = Splashscreen()
        gameOverScreen = GameOverScreen()
        modEngine = ModEngine(game, splashscreen, gameOverScreen)
        modEngine:applyMods()
    else
        modEngine:removeMods()
    end
    love.window.setTitle(game.title)
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    love.graphics.setBackgroundColor(game.backgroundColor)
    

end