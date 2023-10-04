-- main.lua
-- Modify package.path to include your custom directory
package.path = package.path .. ";/opt/homebrew/Cellar/luarocks/3.9.2/share/lua/5.4/?.lua"


local TicTacToe = require("game")
local EventHandler = require("eventHandler")
local ModEngine = require("modEngine")
--Game properties

local boardWidth = 3
local padding = 50
local tileWidth = 200
local windowDimensions = {boardWidth*tileWidth + 100,boardWidth*tileWidth + 150}

local game = TicTacToe()
local eventHandler = EventHandler()
-- local modEngine = ModEngine(game)
-- modEngine:applyMods() -- i didn't lose 30 mins with a . here instead of a :
local winner = nil

local screenText = "Tic Tac Toe"

--Love.load function

function love.load(args)
    love.window.setTitle("Tic Tac Toe")
    --Set size to 300x300
    love.window.setMode(windowDimensions[1], windowDimensions[2], {resizable=false, vsync=false})
end


function love.update(dt)

-- check for win
    winner = game:checkWin()
    if winner then
        screenText = winner .. " wins!"
    end

    -- check for draw
    if game:isFull() then
        screenText = "Draw!"
    end
    
end

function love.draw()
    --Drawing the board
    for i = 1 , boardWidth-1 do
        for j = 1 , boardWidth-1 do
            love.graphics.line(padding + (i)*tileWidth, padding, padding + (i)*tileWidth, padding + tileWidth*boardWidth)
            love.graphics.line(padding, padding + (j)*tileWidth, padding + tileWidth*boardWidth, padding + (j)*tileWidth)
        end
    end
    love.graphics.print (screenText, windowDimensions[1]/2 - string.len(screenText)*3, windowDimensions[2] - 50)

    --Drawing the X's and O's

    local board = game.board

    for i = 1, boardWidth do
        for j = 1, boardWidth do
            if board[i] and board[i][j] then
                if board[i][j] == "X" then
                    love.graphics.line(padding + (j-1)*tileWidth + 10, padding + (i-1)*tileWidth + 10, padding + j*tileWidth - 10, padding + i*tileWidth - 10)
                    love.graphics.line(padding + (j-1)*tileWidth + 10, padding + i*tileWidth - 10, padding + j*tileWidth - 10, padding + (i-1)*tileWidth + 10)
                elseif board[i][j] == "O" then
                    love.graphics.circle("line", padding + (j-1)*tileWidth + tileWidth/2, padding + (i-1)*tileWidth + tileWidth/2, tileWidth/2 - 10)
                end
            end
        end
    end
end

-- Mouse click
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local row = math.floor((y-padding)/tileWidth) + 1
        local col = math.floor((x-padding)/tileWidth) + 1
        if row and col and row >= 1 and row <= boardWidth and col >= 1 and col <= boardWidth then
            if game:makeMove(row, col) then
                eventHandler:raise("move", {col=col, row=row, valid=true})
                winner = game:checkWin()
            else
                print("Invalid move. Try again.")
                eventHandler:raise("move", {col=col, row=row, valid=false})
            end
        else
            print("Invalid input. Please enter valid row and column numbers (1-3).")
        end
    end
end

-- main()
