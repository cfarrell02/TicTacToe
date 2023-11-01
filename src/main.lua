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
    --modEngine:applyMods() -- Applying mods
    WINDOWDIMENSIONS = { BOARDWIDTH * game.tileWidth + 100, BOARDWIDTH * game.tileWidth + 150 }
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
        return
    end

        -- Draw the game board and elements
        if GAMESTATE == "gameover"  then
            gameOverScreen:draw()
            return
        elseif GAMESTATE == "playing" then
            game:draw(game.padding, game.tileWidth)
        end


        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.print(screenText, WINDOWDIMENSIONS[1] / 2 - string.len(screenText) * 6, WINDOWDIMENSIONS[2] - 50)

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



function SaveScores()
    local file = io.open("scores.txt", "w")
    file:write(string.format("%s,%d\n", game.playerOne, game.score[game.playerOne]))
    file:write(string.format("%s,%d\n", game.playerTwo, game.score[game.playerTwo]))
    file:close()
end

function LoadScores()
    local file = io.open("scores.txt", "r")
    if not file then
        return false
    end

    local playerOne, playerTwo, scoreOne, scoreTwo

    -- Read the first line (Player 1)
    local line = file:read()
    if not line then
        file:close()
        return false  -- Error reading the file
    end
    playerOne, scoreOne = string.match(line, "(.+),(.+)")
    if not playerOne or not scoreOne then
        file:close()
        return false  -- Error parsing the line
    end

    -- Read the second line (Player 2)
    line = file:read()
    if not line then
        file:close()
        return false  -- Error reading the file
    end
    playerTwo, scoreTwo = string.match(line, "(.+),(.+)")
    if not playerTwo or not scoreTwo then
        file:close()
        return false  -- Error parsing the line
    end

    -- Update the game data
    game.playerOne = playerOne
    game.playerTwo = playerTwo
    game.score[playerOne] = tonumber(scoreOne)
    game.score[playerTwo] = tonumber(scoreTwo)
    game:reset()

    file:close()
    return true
end
