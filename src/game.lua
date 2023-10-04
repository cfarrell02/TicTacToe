-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local TicTacToe = class.TicTacToe()

function TicTacToe:_init()
    self.board = {}
    self.playerOne = "X"
    self.playerTwo = "Y"
    self.currentPlayer = self.playerOne
end

function TicTacToe:reset()
    self.board = {}
    self.currentPlayer = self.playerOne
end

function TicTacToe:makeMove(row, col)
    if not self.board[row] then
        self.board[row] = {}
    end

    if not self.board[row][col] and (self.currentPlayer == self.playerOne or self.currentPlayer == self.playerTwo) then
        self.board[row][col] = self.currentPlayer
        self:switchPlayer()
        return true
    else
        return false
    end
end

function TicTacToe:switchPlayer()
    if self.currentPlayer == self.playerOne then
        self.currentPlayer = self.playerTwo
    else
        self.currentPlayer = self.playerOne
    end
end

function TicTacToe:checkWin()
    -- Check for a win condition (row, column, diagonal)
    -- Return the winning player ("X" or "O") or nil if no winner yet
end

function TicTacToe:isFull()
    -- Check if the board is full
end

function TicTacToe:printBoard()
    -- Print the current state of the board
    local board = self.board

    -- Print the column headers
    print("  1 2 3")

    for i = 1, 3 do
        io.write(i .. " ")
        for j = 1, 3 do
            local cell = board[i] and board[i][j] or " "
            io.write(cell)
            if j < 3 then
                io.write(" | ")
            end
        end
        print()

        if i < 3 then
            print("  ---------")
        end
    end
end

-- if we have 
function TicTacToe:setPlayerIcons(playerOneIcon, playerTwoIcon)
    self.playerOne = playerOneIcon
    self.playerTwo = playerTwoIcon
    self:reset() -- should this be here or in the mod?
end

return TicTacToe
