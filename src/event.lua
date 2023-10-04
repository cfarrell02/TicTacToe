-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local Event = class.Event()

function Event:_init(name, payload)
    self.name = name
    self.payload = payload -- an event payload class may let us overide tostring
end

function Event:__tostring()
    -- self.payload currently not very useful in tostring, if only there was a way to make it better
    return string.format("Event: %s - Payload: %s", self.name, self.payload)
end

return Event