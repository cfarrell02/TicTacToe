-- Load Penlight's class module
local class = require("pl.class")
local Event = require("event")

-- Define the TicTacToe class
local EventHandler = class.EventHandler()


function EventHandler:_init()
    self.eventLog = {}
end

function EventHandler:raise(eventName, eventPayload)
    self.eventLog[1] = Event(eventName, eventPayload)
    -- maybe an event can have an "effect"
end

function EventHandler:printEventLog(eventName, eventPayload)
    -- todo - print events
end

return EventHandler