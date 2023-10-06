-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local TicTacToe = class.TicTacToe()

function TicTacToe:_init(boardSize)
    self.boardSize = boardSize or 3
    self.board = {}
    self.playerOne = "X"
    self.playerTwo = "O"
    self.score = { X = 0, O = 0 }
    self.currentPlayer = self.playerOne
end

function TicTacToe:reset()
    self.board = {}
    self.currentPlayer = self.playerOne
end

function TicTacToe:resetScores()
    self.score = { X = 0, O = 0 }
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
        if self.board[i] then
            local rowValue = self.board[i][1]
            local rowWin = true
            for j = 2, self.boardSize do
                if not self.board[i][j] or self.board[i][j] ~= rowValue then
                    rowWin = false
                    break
                end
            end
            if rowWin then
                return rowValue
            end
        end

        -- Check columns
        if self.board[1] then
            local colValue = self.board[1][i]
            local colWin = true
            for j = 2, self.boardSize do
                if not self.board[j] or not self.board[j][i] or self.board[j][i] ~= colValue then
                    colWin = false
                    break
                end
            end
            if colWin then
                return colValue
            end
        end
    end

    -- Check diagonals
    if self.board[1] then
        local diagValue1 = self.board[1][1]
        local diagWin1 = true
        for i = 2, self.boardSize do
            if not self.board[i] or not self.board[i][i] or self.board[i][i] ~= diagValue1 then
                diagWin1 = false
                break
            end
        end
        if diagWin1 then
            return diagValue1
        end

        local diagValue2 = self.board[1][self.boardSize]
        local diagWin2 = true
        for i = 2, self.boardSize do
            if not self.board[i] or not self.board[i][self.boardSize - i + 1] or self.board[i][self.boardSize - i + 1] ~= diagValue2 then
                diagWin2 = false
                break
            end
        end
        if diagWin2 then
            return diagValue2
        end
    end

    return false
end

function TicTacToe:incrementScore(player)
    self.score[player] = self.score[player] + 1
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

function TicTacToe:draw(padding, tileWidth)
   -- Drawing the board grid
   for i = 1, self.boardSize - 1 do
    for j = 1, self.boardSize - 1 do
        love.graphics.line(padding + i * tileWidth, padding, padding + i * tileWidth, padding + tileWidth * self.boardSize)
        love.graphics.line(padding, padding + j * tileWidth, padding + tileWidth * self.boardSize, padding + j * tileWidth)
    end
end

    -- Drawing the X's and O's

    for i = 1, self.boardSize do
        for j = 1, self.boardSize do
            if self.board[i] and self.board[i][j] then
                if self.board[i][j] == "X" then
                    --Two lines to make an X
                    love.graphics.line(padding + (j - 1) * tileWidth + 10, padding + (i - 1) * tileWidth + 10, padding + j * tileWidth - 10, padding + i * tileWidth - 10)
                    love.graphics.line(padding + (j - 1) * tileWidth + 10, padding + i * tileWidth - 10, padding + j * tileWidth - 10, padding + (i - 1) * tileWidth + 10)
                elseif self.board[i][j] == "O" then
                    --Circle to make an O
                    love.graphics.circle("line", padding + (j - 1) * tileWidth + tileWidth / 2, padding + (i - 1) * tileWidth + tileWidth / 2, tileWidth / 2 - 10)
                end
            end
        end
    end
end

return TicTacToe
