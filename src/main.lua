-- main.lua

local TicTacToe = require("src/game")
local EventHandler = require("src/eventHandler")
local ModEngine = require("src/modEngine")

local text = "Hello World!"

--Love.load function

function love.load(args)
    love.window.setTitle("Tic Tac Toe")
    --Set size to 300x300
    love.window.setMode(400,400)
end


function love.update(dt)
    local game = TicTacToe()
    local eventHandler = EventHandler()
    local modEngine = ModEngine(game)
    modEngine:applyMods() -- i didn't lose 30 mins with a . here instead of a :
    local winner = nil
    text = os.clock()

    
end

function love.draw()
    --Drawing the board
    love.graphics.line(150,50,150,350)
    love.graphics.line(250,50,250,350)
    love.graphics.line(50,150,350,150)
    love.graphics.line(50,250,350,250)

    love.graphics.print(text, 100, 100)
end

-- function main()
--     local game = TicTacToe()
--     local eventHandler = EventHandler()
--     local modEngine = ModEngine(game)
--     modEngine:applyMods() -- i didn't lose 30 mins with a . here instead of a :
--     local winner = nil

--     while not winner and not game:isFull() do
--         print("Current Player: " .. game.currentPlayer)
--         game:printBoard()
        
--         -- Get user input for row and column
--         print("Enter row (1-3) and column (1-3): ")
--         local row, col = tonumber(io.read()), tonumber(io.read())
        
--         if row and col and row >= 1 and row <= 3 and col >= 1 and col <= 3 then
--             if game:makeMove(row, col) then
--                 eventHandler:raise("move", {col=col, row=row, valid=true})
--                 winner = game:checkWin()
--             else
--                 print("Invalid move. Try again.")
--                 eventHandler:raise("move", {col=col, row=row, valid=false})
--             end
--         else
--             print("Invalid input. Please enter valid row and column numbers (1-3).")
--         end
--     end

--     game:printBoard()

--     if winner then
--         print("Player " .. winner .. " wins!")
--     else
--         print("It's a draw!")
--     end
-- end

-- main()
