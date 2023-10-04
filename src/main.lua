-- main.lua

local TicTacToe = require("src/game")
local EventHandler = require("src/eventHandler")
local ModEngine = require("src/modEngine")

function main()
    local game = TicTacToe()
    local eventHandler = EventHandler()
    local modEngine = ModEngine(game)
    modEngine:applyMods() -- i didn't lose 30 mins with a . here instead of a :
    local winner = nil

    while not winner and not game:isFull() do
        print("Current Player: " .. game.currentPlayer)
        game:printBoard()
        
        -- Get user input for row and column
        print("Enter row (1-3) and column (1-3): ")
        local row, col = tonumber(io.read()), tonumber(io.read())
        
        if row and col and row >= 1 and row <= 3 and col >= 1 and col <= 3 then
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

    game:printBoard()

    if winner then
        print("Player " .. winner .. " wins!")
    else
        print("It's a draw!")
    end
end

main()
