local class = require("pl.class")

local Splashscreen = class.Splashscreen()
local EventHandler = require("eventHandler")

local Button = require("button")
local eventHandler = EventHandler()


function Splashscreen:_init()
    self.titleText = "Tic Tac Toe"
    self.animationTimer = 0
    self.blinkDuration = 1
    self.showText = true
    self.font = love.graphics.newFont(WINDOWDIMENSIONS[1] / 10)
    self.titleX = (WINDOWDIMENSIONS[1] - self.font:getWidth(self.titleText)) / 2
    self.titleY = (WINDOWDIMENSIONS[2] - self.font:getHeight()) / 2 - 50
    self.buttons = {}

    for i = 3, 5 do
    local button = Button(
        WINDOWDIMENSIONS[1] / 2 - 150 + 105*(i-3), -- x
        WINDOWDIMENSIONS[2] -90, -- y
        100, -- width
        50, -- height
        string.format("Grid Size %s", i), -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            if BOARDWIDTH ~= i then
                ResetGameWidth(i)
            end
        end
    )
    table.insert(self.buttons, button)    
    end

    -- Single/Multiplayer button
    local button = Button(
        WINDOWDIMENSIONS[1] / 2 - 50, -- x
        WINDOWDIMENSIONS[2] / 2 + 150, -- y
        100, -- width
        50, -- height
        GAMEMODE, -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            if GAMEMODE == "Singleplayer" then
                GAMEMODE = "Multiplayer"
            else
                GAMEMODE = "Singleplayer"
            end
        end
    )
    table.insert(self.buttons, button)

    local saveButton = Button(
        50, -- x
        50, -- y
        100, -- width
        50, -- height
        "Save", -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            SaveScores()
        end
    )
    table.insert(self.buttons, saveButton)

    local loadButton = Button(
        50, -- x
        110, -- y
        100, -- width
        50, -- height
        "Load", -- text
        love.graphics.newFont(16), -- font
        {0.58, 0.78, 0.92, 1}, -- light blue color
        {0.196, 0.325, 0.62, 1}, -- hoverColor
        {0.67, 0.63, 0.95, 1}, -- clickColor
        function()
            LoadScores()
        end
    )
    table.insert(self.buttons, loadButton)

    for i = 1, 2 do 
        local y = 50 * i
        if i == 2 then
            y = 110
        end
        local enableDisableMods = Button(
            WINDOWDIMENSIONS[1] - 150, -- x
            y, -- y
            100, -- width
            50, -- height
            i==1 and "Mods On" or "Mods Off", -- text
            love.graphics.newFont(16), -- font
            {0.58, 0.78, 0.92, 1}, -- light blue color
            {0.196, 0.325, 0.62, 1}, -- hoverColor
            {0.67, 0.63, 0.95, 1}, -- clickColor
            function()
                SetMods(i==1)
            end
        )
        table.insert(self.buttons, enableDisableMods)
    end



    -- Create background Xs and Os
    self.backgroundXs = {}
    self.backgroundOs = {}
    for i = 1, 20 do
        table.insert(self.backgroundXs, {
            x = love.math.random(0, WINDOWDIMENSIONS[1]),
            y = love.math.random(0, WINDOWDIMENSIONS[2]),
            speed = love.math.random(20, 50),
            size = love.math.random(5, 30),
        })
        table.insert(self.backgroundOs, {
            x = love.math.random(0, WINDOWDIMENSIONS[1]),
            y = love.math.random(0, WINDOWDIMENSIONS[2]),
            speed = love.math.random(20, 50),
            size = love.math.random(5, 20),
        })
    end
end

function Splashscreen:draw()
    if GAMESTATE == "playing" then
        return
    end

    love.graphics.setColor(1, 1, 1)

    -- Draw Xs and Os as moving shapes in the background
    for _, x in ipairs(self.backgroundXs) do
        love.graphics.line(x.x, x.y, x.x + x.size, x.y + x.size)
        love.graphics.line(x.x, x.y + x.size, x.x + x.size, x.y)
        x.y = x.y + x.speed * love.timer.getDelta()
        if x.y > WINDOWDIMENSIONS[2] + x.size then
            x.y = -x.size
            x.x = love.math.random(0, WINDOWDIMENSIONS[1])
        end
    end

    for _, o in ipairs(self.backgroundOs) do
        love.graphics.circle("line", o.x, o.y, o.size)
        o.y = o.y + o.speed * love.timer.getDelta()
        if o.y > WINDOWDIMENSIONS[2] + o.size then
            o.y = -o.size
            o.x = love.math.random(0, WINDOWDIMENSIONS[1])
        end
    end

    -- Draw the title text    
        love.graphics.setFont(self.font)
        love.graphics.print(self.titleText, self.titleX, self.titleY)
    
    --Blinking start text
    if self.showText then
    love.graphics.setFont(love.graphics.newFont(WINDOWDIMENSIONS[1] / 20))
    love.graphics.print("Press space to start", WINDOWDIMENSIONS[1] / 2 - WINDOWDIMENSIONS[1] * 0.25, WINDOWDIMENSIONS[2] / 2 + 50)
    end

    love.graphics.setFont(love.graphics.newFont(16))

    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function Splashscreen:mousepressed(x, y, button)
    for _, button in ipairs(self.buttons) do
        button:mousepressed(x, y, button)
    end
end

function Splashscreen:update(dt)
    if love.keyboard.isDown("space") then
        GAMESTATE = "playing"
    end


    for _, button in ipairs(self.buttons) do
        button:update(dt)
        if button.text == "Singleplayer" or button.text == "Multiplayer" then
            button.text = GAMEMODE
        end
    end
   
    

    -- Blinking for the title text
    self.animationTimer = self.animationTimer + dt
    if self.animationTimer >= self.blinkDuration then
        self.animationTimer = self.animationTimer - self.blinkDuration
        self.showText = not self.showText
    end
end

return Splashscreen
