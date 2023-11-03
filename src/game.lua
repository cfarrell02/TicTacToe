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
    self.padding = 50
    self.tileWidth = 200
    self.completeMoveList = {}
    self.score = {  }	
    self.score[self.playerOne] = 0
    self.score[self.playerTwo] = 0
    self.currentPlayer = self.playerOne
    self.buttons = {}
    self.backgroundColor = {0.208, 0.6, 0.941}
    self.gameOverTimer = 0
    self.gameOverDelay = 2 -- Adjust this value to set the delay in seconds
    -- Mod Functions to be called
    self.modDrawFunctions = {}

    -- undo button
    local undo = Button(
        20, -- x
        WINDOWDIMENSIONS[2] - 60, -- y
        100, -- width
        50, -- height
        LABELS:getLabel("Undo_Button_Label"), -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
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
        LABELS:getLabel("Redo_Button_Label"), -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            self:redoLastMove()
        end
    )
    table.insert(self.buttons, redo)

end

function TicTacToe:registerModDrawFunction(func)
    table.insert(self.modDrawFunctions, func)
end

function TicTacToe:clearModDrawFunctions()
    self.modDrawFunctions = {}
end

function TicTacToe:drawModElements()
    for _, func in ipairs(self.modDrawFunctions) do
        func()
    end
end

function TicTacToe:reset()
    self.board = {}
    self.currentPlayer = self.playerOne
    self.moveList = {}
    self.completeMoveList = {}
end

function TicTacToe:resetScores()
    self.score = {  }
    self.score[self.playerOne] = 0
    self.score[self.playerTwo] = 0
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
        SetScreenText(string.format(LABELS:getLabel("Undone_Template"), self.currentPlayer))
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
        SetScreenText(string.format(LABELS:getLabel("Redone_Template"), self.currentPlayer))
        return true
    else
        return false
    end
end



function TicTacToe:makeMove(row, col)
    --Do not make move if AI move is pending
    if GAMEMODE == LABELS:getLabel("Singleplayer_Button_Label") and self.currentPlayer == self.playerTwo and love.timer.getTime() < self.aiMoveTime then
        SetScreenText(LABELS:getLabel("AI_Pending_Text"))
        return false
    end

    if not self.board[row] then
        self.board[row] = {}
    end

    if not self.board[row][col] and (self.currentPlayer == self.playerOne or self.currentPlayer == self.playerTwo) then
        self.board[row][col] = self.currentPlayer
        self:switchPlayer()
        table.insert(self.moveList, { row, col })
        self.completeMoveList = copyTable(self.moveList)
        return true
    else
        SetScreenText(LABELS:getLabel("Invalid_Move_Text"))
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
            table.insert(self.moveList, { row, col })
            self.completeMoveList = copyTable(self.moveList)
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
            table.insert(self.moveList, { row, col })
            self.completeMoveList = copyTable(self.moveList)
            return true
        end
        self.board[row][col] = nil
    end

    -- Place in the center if available
    if not self.board[2] or (self.board[2] and not self.board[2][2]) then
        self.board[2] = self.board[2] or {} -- Create the row if it doesn't exist
        self.board[2][2] = self.currentPlayer
        self:switchPlayer()
        table.insert(self.moveList, { 2, 2 })
        self.completeMoveList = copyTable(self.moveList)
        return true
    end

    -- Place in a corner if available
    local corners, counter = 4 , 1
    for _, cell in ipairs(emptyCells) do
        local row, col = unpack(cell)
        if (row == 1 or row == self.boardSize) and (col == 1 or col == self.boardSize) then -- Check if the cell is a corner
            self.board[row] = self.board[row] or {} -- Create the row if it doesn't exist
            self.board[row][col] = self.currentPlayer 
            self:switchPlayer()
            table.insert(self.moveList, { row, col })
            self.completeMoveList = copyTable(self.moveList)
            return true
        end
    end

    -- If there are no winning or blocking moves, make a random move
    local randomIndex = love.math.random(1, #emptyCells)
    local row, col = unpack(emptyCells[randomIndex])
    self.board[row] = self.board[row] or {}
    self.board[row][col] = self.currentPlayer
    self:switchPlayer()
    table.insert(self.moveList, { row, col })
    self.completeMoveList = copyTable(self.moveList)
    return true
end

function TicTacToe:switchPlayer()
    if self.currentPlayer == self.playerOne then
        self.currentPlayer = self.playerTwo
        if GAMEMODE == LABELS:getLabel("Singleplayer_Button_Label") then
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
                return {winner = rowValue, row = i, direction = "horizontal"}
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
                return {winner = colValue, col = i, direction = "vertical"}
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
            return {winner = diagValue1, direction = "diagonal", slope = 1}
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
            return {winner = diagValue2, direction = "diagonal", slope = -1}
        end
    end

    return false
end

function TicTacToe:incrementScore(player)
    self.score[player] = self.score[player] + 1
end




function TicTacToe:isFull()
    for i = 1, BOARDWIDTH do
        for j = 1, BOARDWIDTH do
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
    self:resetScores()
end

function TicTacToe:setTheme(theme)
    if theme == "light" then
        self.backgroundColor = {0.208, 0.6, 0.941}
    elseif theme == "dark" then
        self.backgroundColor = {0, 0.161, 0.302}
    end
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
                local rowCoords = padding + (i - 1) * tileWidth
                local colCoords = padding + (j - 1) * tileWidth
                love.graphics.setColor(1, 1, 1)
    
                -- Calculate the scaling factor based on the tile size
                local maxTextWidth = tileWidth * 0.6  -- Adjust this value as needed
                local text = self.board[i][j]
                local currentFontSize = love.graphics.getFont():getHeight()
                local scale = math.min(maxTextWidth / love.graphics.getFont():getWidth(text), tileWidth / 4)
    
                -- Set the font size based on the calculated scale
                love.graphics.setFont(love.graphics.newFont(currentFontSize * scale))
    
                -- Center the text within the tile
                local textWidth = love.graphics.getFont():getWidth(text)
                local textHeight = love.graphics.getFont():getHeight()
                local textX = colCoords + (tileWidth - textWidth) / 2
                local textY = rowCoords + (tileWidth - textHeight) / 2
    
                love.graphics.print(self.board[i][j], textX, textY)
            end
        end
    end
    
    

    -- Check if the mouse is hovering over a tile
    local row = math.floor((love.mouse.getY() - padding) / tileWidth) + 1
    local col = math.floor((love.mouse.getX() - padding) / tileWidth) + 1
    local rowCoords = padding + (row - 1) * tileWidth
    local colCoords = padding + (col - 1) * tileWidth
    if row and col and row >= 1 and row <= self.boardSize and col >= 1 and col <= self.boardSize then
        if not self.board[row] then
            HighlightBox(colCoords, rowCoords, tileWidth, tileWidth, { 1, 1, 1, 0.2 })
        elseif not self.board[row][col] then
            HighlightBox(colCoords, rowCoords, tileWidth, tileWidth, { 1, 1, 1, 0.2 })
        end
        
    end

    for _, button in ipairs(self.buttons) do
        button:draw()
    end

    local winner = self:checkWin()
    if winner then
        self:drawWinningLine(winner)
    end
end

function TicTacToe:drawWinningLine(win)

    local padding = 50
    local tileWidth = 200
    local winType = win.direction
    if winType == "horizontal" then
        for i = 1, self.boardSize do
        HighlightBox(padding, padding + (win.row - 1) * tileWidth, tileWidth * self.boardSize, tileWidth, { 1, 1, 1, 0.2 })
        end
    elseif winType == "vertical" then
        for i = 1, self.boardSize do
        HighlightBox(padding + (win.col - 1) * tileWidth, padding, tileWidth, tileWidth * self.boardSize, { 1, 1, 1, 0.2 })
        end
    elseif winType == "diagonal" then
        if win.slope == 1 then
            for i = 1, self.boardSize do
                HighlightBox(padding + (i - 1) * tileWidth, padding + (i - 1) * tileWidth, tileWidth, tileWidth, { 1, 1, 1, 0.2 })
            end
        elseif win.slope == -1 then
            for i = 1, self.boardSize do
                HighlightBox(padding + (i - 1) * tileWidth, padding + (self.boardSize - i) * tileWidth, tileWidth, tileWidth, { 1, 1, 1, 0.2 })
            end
        end
    end

end

function TicTacToe:update(dt)
    if GAMEMODE == LABELS:getLabel("Singleplayer_Button_Label") and self.currentPlayer == self.playerTwo then
        if love.timer.getTime() >= self.aiMoveTime then
            self:makeAIMove()
        end
    end
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end

    local winner = self:checkWin()


    if winner then
        winner = winner.winner
        SetScreenText(string.format(LABELS:getLabel("Win_Text_Template"), winner))
        self.gameOverTimer = self.gameOverTimer + dt
        
        if self.gameOverTimer >= self.gameOverDelay then
            self.gameOverTimer = 0
            ShowGameOverScreen(string.format(LABELS:getLabel("Win_Text_Template"), winner))
            --eventHandler:raise("win", { winner = winner })
            self:incrementScore(winner)
            self:reset()
            SetScoreText(string.format(LABELS:getLabel("Score_Text_Template"), self.playerOne, self.score[self.playerOne], self.playerTwo, self.score[self.playerTwo] ))
        end

    elseif self:isFull() then
        self.gameOverTimer = self.gameOverTimer + dt
        if self.gameOverTimer >= self.gameOverDelay then
            self.gameOverTimer = 0
            ShowGameOverScreen(LABELS:getLabel("Draw_Text"))
            --eventHandler:raise("draw")
            self:reset()
        end
    end
end



function TicTacToe:mousepressed(x,y,button) 
    for _, button in ipairs(self.buttons) do
        button:mousepressed(x, y, button)
    end
end

function copyTable (t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

return TicTacToe
