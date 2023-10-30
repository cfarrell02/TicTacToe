-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local TicTacToe = class.TicTacToe()

local Button = require("button")

function TicTacToe:_init(boardSize)
    self.boardSize = boardSize or 3
    self.board = {}
    self.playerOne = "X"
    self.playerTwo = "O"
    self.moveList = {}
    self.completeMoveList = {}
    self.score = { X = 0, O = 0 }
    self.currentPlayer = self.playerOne
    self.buttons = {}

    -- undo button
    local undo = Button(
        20, -- x
        WINDOWDIMENSIONS[2] - 60, -- y
        100, -- width
        50, -- height
        "Undo", -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.31, 0, 0.4, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            self:undoLastMove()
        end
    )
    table.insert(self.buttons, undo)

    -- redo button
    local redo = Button(
        WINDOWDIMENSIONS[1] - 120, -- x
        WINDOWDIMENSIONS[2] - 60, -- y
        100, -- width
        50, -- height
        "Redo", -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.31, 0, 0.4, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            self:redoLastMove()
        end
    )
    table.insert(self.buttons, redo)

end

function TicTacToe:reset()
    self.board = {}
    self.currentPlayer = self.playerOne
    self.moveList = {}
    self.completeMoveList = {}
end

function TicTacToe:resetScores()
    self.score = { X = 0, O = 0 }
end

function TicTacToe:undoMove(row, col)
    if self.board[row] and self.board[row][col] then
        self.board[row][col] = nil
        self:switchPlayer()
        return true
    else
        return false
    end
end

function TicTacToe:undoLastMove()
    if #self.moveList > 0 then
        local row, col = unpack(self.moveList[#self.moveList])
        self:undoMove(row, col)
        table.remove(self.moveList, #self.moveList)
        SETSCREENTEXT(string.format("Undone %s's move", self.currentPlayer))
        return true
    else
        return false
    end
end

function TicTacToe:redoLastMove()
    if #self.moveList < #self.completeMoveList then
        local row, col = unpack(self.completeMoveList[#self.moveList + 1])
        self.board[row][col] = self.currentPlayer
        self:switchPlayer()
        table.insert(self.moveList, { row, col })
        SETSCREENTEXT(string.format("Redone %s's move", self.currentPlayer))
        return true
    else
        return false
    end
end



function TicTacToe:makeMove(row, col)
    --Do not make move if AI move is pending
    if GAMEMODE == "Singleplayer" and self.currentPlayer == self.playerTwo and love.timer.getTime() < self.aiMoveTime then
        SETSCREENTEXT("AI move pending")
        return false
    end

    if not self.board[row] then
        self.board[row] = {}
    end

    if not self.board[row][col] and (self.currentPlayer == self.playerOne or self.currentPlayer == self.playerTwo) then
        self.board[row][col] = self.currentPlayer
        self:switchPlayer()
        table.insert(self.moveList, { row, col })
        table.insert(self.completeMoveList, { row, col })
        return true
    else
        SETSCREENTEXT("Invalid move!")
        return false
    end
end


function TicTacToe:makeAIMove()
    local emptyCells = {}
    for i = 1, self.boardSize do
        for j = 1, self.boardSize do
            if not self.board[i] or not self.board[i][j] then
                table.insert(emptyCells, {i, j})
            end
        end
    end

    if #emptyCells == 0 then
        return false
    end

    -- Check for a winning move
    for _, cell in ipairs(emptyCells) do
        local row, col = unpack(cell)
        self.board[row] = self.board[row] or {}
        self.board[row][col] = self.currentPlayer
        if self:checkWin(self.currentPlayer) then
            self:switchPlayer()
            return true
        end
        self.board[row][col] = nil
    end

    -- Check for a blocking move
    local opponent = (self.currentPlayer == self.playerOne) and self.playerTwo or self.playerOne
    for _, cell in ipairs(emptyCells) do
        local row, col = unpack(cell)
        self.board[row] = self.board[row] or {}
        self.board[row][col] = opponent
        if self:checkWin(opponent) then
            self.board[row][col] = self.currentPlayer
            self:switchPlayer()
            return true
        end
        self.board[row][col] = nil
    end

    -- If there are no winning or blocking moves, make a random move
    local randomIndex = love.math.random(1, #emptyCells)
    local row, col = unpack(emptyCells[randomIndex])
    self.board[row] = self.board[row] or {}
    self.board[row][col] = self.currentPlayer
    self:switchPlayer()
    table.insert(self.moveList, { row, col })
    table.insert(self.completeMoveList, { row, col })
    return true
end

function TicTacToe:switchPlayer()
    if self.currentPlayer == self.playerOne then
        self.currentPlayer = self.playerTwo
        if GAMEMODE == "Singleplayer" then
            -- Store the time when the AI should make a move
            self.aiMoveTime = love.timer.getTime() + 2
        end
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

    -- Check if the mouse is hovering over a tile
    local row = math.floor((love.mouse.getY() - padding) / tileWidth) + 1
    local col = math.floor((love.mouse.getX() - padding) / tileWidth) + 1
    local rowCoords = padding + (row - 1) * tileWidth
    local colCoords = padding + (col - 1) * tileWidth
    if row and col and row >= 1 and row <= BOARDWIDTH and col >= 1 and col <= BOARDWIDTH then
        highlightBox(colCoords, rowCoords, tileWidth, tileWidth, { 1, 1, 1, 0.2 })
    end

    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function TicTacToe:update(dt)
    if GAMEMODE == "Singleplayer" and self.currentPlayer == self.playerTwo then
        if love.timer.getTime() >= self.aiMoveTime then
            self:makeAIMove()
        end
    end
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function TicTacToe:mousepressed(x,y,button) 
    for _, button in ipairs(self.buttons) do
        button:mousepressed(x, y, button)
    end
end

return TicTacToe
