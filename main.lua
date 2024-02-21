local PID = require "PID.PID"
local PIDReactorController = require "PID.PIDReactorController"

local pid = PID.new(0.1, 0.01, 0.05)
local reactor = peripheral.wrap("BigReactors-Reactor_3")
local reactorController = PIDReactorController.new(reactor, pid, 10000)
reactorController:controlReactor()
