local PID = require "PID.PID"
local PIDReactorController = require "PID.PIDReactorController"

local pid = PID.new(0.1, 0.01, 0.05)
local reactor = peripheral.wrap("BigReactors-Reactor_3")
local reactorController = PIDReactorController.new(reactor, pid, 10000)

local function sleep(n --[[number]])
    local timer = os.startTimer(n)
    repeat
        local _, _timer = os.pullEvent("timer")
    until timer == _timer
end

while true do
    print(reactorController)
    reactorController:controlReactor()
    print()
    print()

    sleep(0.1)
end
