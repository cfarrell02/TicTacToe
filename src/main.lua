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
local Label = require("labels")

--Global variables
LABELS = Label("labels.txt")
BOARDWIDTH = 3
GAMESTATE = "splashscreen"
GAMEMODE = LABELS:getLabel("Singleplayer_Button_Label")
WINDOWDIMENSIONS = { BOARDWIDTH * 200 + 100, BOARDWIDTH * 200 + 150}





-- Initialize game-related objects
local game = TicTacToe(BOARDWIDTH)
local eventHandler = EventHandler()
local splashscreen = Splashscreen()
local gameOverScreen = GameOverScreen()
local modEngine = ModEngine(game, splashscreen, LABELS)
local screenText = ""
local scoreText = ""
local notification = { text = "", duration = 0 }
local modsEnabled = false



-- Love.load function
function love.load(args)
    WINDOWDIMENSIONS = { BOARDWIDTH * game.tileWidth + 100, BOARDWIDTH * game.tileWidth + 150 }
    love.window.setTitle(LABELS:getLabel("Main_Title"))
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    love.graphics.setBackgroundColor(game.backgroundColor)
    SetScoreText(string.format(LABELS:getLabel("Score_Text_Template"), game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))
    screenText = string.format(LABELS:getLabel("Player_Turn_Template"), game.currentPlayer)
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
        SetScoreText(string.format(LABELS:getLabel("Score_Text_Template"), game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))
        screenText = string.format(LABELS:getLabel("Player_Turn_Template"), game.currentPlayer)
    end

    if GAMESTATE == "playing" then
            game:update(dt)
        else if GAMESTATE == "gameover" then
            gameOverScreen:update(dt)
        end
    end
    
    if notification.duration > 0 then
        notification.duration = notification.duration - dt
    end

end

-- Love.draw function
function love.draw()
    -- Draw the score
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.print(scoreText, WINDOWDIMENSIONS[1] / 2 - string.len(scoreText) * 4, 10)
    
    if GAMESTATE == "splashscreen" then
        splashscreen:draw()
        -- Draw the game board and elements
    elseif GAMESTATE == "gameover"  then
        gameOverScreen:draw()
    elseif GAMESTATE == "playing" then
        game:draw(game.padding, game.tileWidth)
        DrawText(screenText, 16, WINDOWDIMENSIONS[1] / 2, WINDOWDIMENSIONS[2] - 30, WINDOWDIMENSIONS[1] * 0.5)
    end

    -- Draw the notification
    if notification.duration > 0 then
        DrawText(notification.text, 10, WINDOWDIMENSIONS[1]/2 , WINDOWDIMENSIONS[2] -10, WINDOWDIMENSIONS[1] * 0.5)
        notification.duration = notification.duration - love.timer.getDelta()
    end


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
                    screenText = string.format(LABELS:getLabel("Player_Turn_Template"), game.currentPlayer)
                    winner = game:checkWin()
                else
                    eventHandler:raise("move", { col = col, row = row, valid = false })
                end
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
    if modsEnabled then
        SetMods(true)
    end
    SetScoreText(string.format(LABELS:getLabel("Score_Text_Template"), game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))
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
    file:write(string.format("%s\n", modsEnabled and "true" or "false"))
    file:close()
end

function LoadScores()
    local file = io.open("scores.txt", "r")
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end

        if #lines ~= 4 then
            return
        end


        --Check if mods were enabled
        if lines[4] ~= (modsEnabled and "true" or "false") then
            DisplayNotification(LABELS:getLabel("Incompatible_Save_Notification_Text"), 2)
            return
        end

        -- Player 1
        game.playerOne = string.sub(lines[1], 1, string.find(lines[1], ",") - 1)
        game.score[game.playerOne] = tonumber(string.sub(lines[1], string.find(lines[1], ",") + 1))

        -- Player 2
        game.playerTwo = string.sub(lines[2], 1, string.find(lines[2], ",") - 1)
        game.score[game.playerTwo] = tonumber(string.sub(lines[2], string.find(lines[2], ",") + 1))

        SetScoreText(string.format(LABELS:getLabel("Score_Text_Template"), game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] ))

        -- Board width
        
        if BOARDWIDTH ~= tonumber(lines[3]) then
            ResetGameWidth(tonumber(lines[3]))
        end
    end
end

function DrawText(text, fontSize, x, y, maxWidth)
    love.graphics.setFont(love.graphics.newFont(fontSize))
    local maxTextWidth = maxWidth or WINDOWDIMENSIONS[1]
    local currentFont = love.graphics.getFont():getHeight()
    local scale = math.min(maxTextWidth / love.graphics.getFont():getWidth(text), 1)
    love.graphics.setFont(love.graphics.newFont(currentFont * scale))
    
    local width = love.graphics.getFont():getWidth(text)
    love.graphics.print(text, x - width / 2, y - love.graphics.getFont():getHeight() / 2)
end

function DisplayNotification(text, duration)
    notification.text = text
    notification.duration = duration
end


function SetMods(enabled)
    if enabled and not modsEnabled then
        -- Refresh everything
        modsEnabled = true
        modEngine:applyLabelMods()
        GAMEMODE = LABELS:getLabel("Singleplayer_Button_Label")
        --ResetGameWidth(BOARDWIDTH)
        game = TicTacToe(BOARDWIDTH)
        splashscreen = Splashscreen()
        modEngine = ModEngine(game, splashscreen, LABELS)
        modEngine:applyMods()
    elseif not enabled and modsEnabled then

        modsEnabled = false
        modEngine:removeMods()
        GAMEMODE = LABELS:getLabel("Singleplayer_Button_Label")
        game = TicTacToe(BOARDWIDTH)
        splashscreen = Splashscreen()
        ResetGameWidth(BOARDWIDTH)

    end
    love.window.setTitle(LABELS:getLabel("Main_Title"))
    love.window.setMode(WINDOWDIMENSIONS[1], WINDOWDIMENSIONS[2], { resizable = false, vsync = false })
    scoreText = string.format(LABELS:getLabel("Score_Text_Template"), game.playerOne, game.score[game.playerOne], game.playerTwo, game.score[game.playerTwo] )
    love.graphics.setBackgroundColor(game.backgroundColor)
    

end