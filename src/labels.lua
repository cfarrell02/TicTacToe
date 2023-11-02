local pl = require 'pl.import_into'()

local Labels = pl.class()

function Labels:_init(filename)
    self.fileName = filename
    self.labels = {}
    local inputDir = "data"

    local file = love.filesystem.newFile(inputDir .. "/" .. filename)
    file:open("r")
    local lines = file:read()

    -- Labels are written as key : value

    for line in lines:gmatch("[^\r\n]+") do
        local key = string.sub(line, 1, string.find(line, ":") - 1)
        local value = string.sub(line, string.find(line, ":") + 1)
        self.labels[key] = value
       -- print(key .. " -- " ..value)
    end

    file:close()

end

function Labels:reloadLabels()
    self.labels = {}
    local inputDir = "data"

    local file = love.filesystem.newFile(inputDir .. "/" .. self.fileName)
    file:open("r")
    local lines = file:read()

    -- Labels are written as key : value

    for line in lines:gmatch("[^\r\n]+") do
        local key = string.sub(line, 1, string.find(line, ":") - 1)
        local value = string.sub(line, string.find(line, ":") + 1)
        self.labels[key] = value
        --print(key .. " -- " ..value)
    end

    file:close()
end

function Labels:getLabel(key)
    if self.labels[key] == nil then
        return "Label not found"
    end
    return self.labels[key]
end

function Labels:replaceLabel(key, value)
    if self.labels[key] == nil then
        return "Label not found"
    end
    self.labels[key] = value
end

function Labels:addLabel(key, value)
    if self.labels[key] ~= nil then
        return "Label already exists"
    end
    self.labels[key] = value
end


-- Add more getters for each label as needed

return Labels
