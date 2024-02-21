local PIDReactorController = require "PID.PIDReactorController"
local Reactor = peripheral.wrap("BigReactors-Reactor_3")

local ReactorController = PIDReactorController.new(Reactor)

local function sleep(n)
    local timer = os.startTimer(n)
    repeat
        local _, _timer = os.pullEvent("timer")
    until timer == _timer
end

while true do
    ReactorController:doTick()
    sleep(.2)
end
