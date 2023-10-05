-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local TicTacToe = class.TicTacToe()

function TicTacToe:_init(boardSize)
    self.boardSize = boardSize or 3
    self.board = {}
    self.playerOne = "X"
    self.playerTwo = "O"
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
    for i = 1, self.boardSize do
        -- Check rows
        if self.board[i] and self.board[i][1] and self.board[i][1] == self.board[i][2] and self.board[i][1] == self.board[i][3] then
            return self.board[i][1]
        end

        -- Check columns
        if self.board[1] and self.board[2] and self.board[3] and self.board[1][i] and self.board[1][i] == self.board[2][i] and self.board[1][i] == self.board[3][i] then
            return self.board[1][i]
        end

    end
 -- Check diagonals
    for i = 1, self.boardSize do 
        if not self.board[i] then
            return false
        end
    end
    if self.board[1][1] and self.board[1][1] == self.board[2][2] and self.board[1][1] == self.board[3][3] then
        return self.board[1][1]
    end
    if self.board[1][3] and self.board[1][3] == self.board[2][2] and self.board[1][3] == self.board[3][1] then
        return self.board[1][3]
    end
end

function TicTacToe:isFull()
    for i = 1, 3 do
        for j = 1, 3 do
            if not self.board[i] or not self.board[i][j] then
                return false
            end
        end
    end

    return true
end

-- if we have 
function TicTacToe:setPlayerIcons(playerOneIcon, playerTwoIcon)
    self.playerOne = playerOneIcon
    self.playerTwo = playerTwoIcon
    self:reset() -- should this be here or in the mod?
end

return TicTacToe
