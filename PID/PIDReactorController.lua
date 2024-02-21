local PID = require "PID.PID"

local PIDReactorSteamMode = {}

function PIDReactorSteamMode.new(reactorObject)
    local self = setmetatable({}, { __index = PIDReactorSteamMode })

    self.pid = PID.new(0.5, 0.1, 0.01)
    self.reactor = reactorObject

    self.last_tick = os.clock()

    return self
end

function PIDReactorSteamMode.doTick(self)
    -- Activate reactor
    self.reactor.setActive(true)

    local ct = os.clock()
    local dt = ct - self.last_tick

    local hotFluidLastTick = self.reactor.getHotFluidProducedLastTick()

    local power = 100 - self.pid:calc(10000, hotFluidLastTick, dt)

    self.reactor.setAllControlRodLevels(power)
end

return PIDReactorSteamMode
