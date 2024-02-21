local PID = require "PID.PID"

local PIDReactorSteamMode = {}

function PIDReactorSteamMode.new(reactorObject)
    local self = setmetatable({}, { __index = PIDReactorSteamMode })

    self.pid = PID.new(0.5, 0.1, 0.01)
    self.reactor = reactorObject

    self.last_tick = os.clock()
    self.backlog = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    self.backlog_i = 1

    return self
end

function PIDReactorSteamMode.doTick(self)
    -- Activate reactor
    self.reactor.setActive(true)

    local ct = os.clock()
    local dt = ct - self.last_tick

    local hotFluidLastTick = self.reactor.getHotFluidProducedLastTick()
    self:insertToBacklog(hotFluidLastTick)

    local power = 100 - self.pid:calc(10000, self:getAverage(), dt)

    print(string.format("CT: %f\nDT: %f\nHFLT: %f\nAVG: %f\nRODS: %d -> %d\n\n", ct, dt, hotFluidLastTick,
        self:getAverage(), self.reactor.getControlRodLevel(1), power))

    self.last_tick = ct
    self.reactor.setAllControlRodLevels(power)
end

function PIDReactorSteamMode.insertToBacklog(self, v)
    if self.backlog_i > 10 then
        self.backlog_i = 1
    end

    self.backlog[self.backlog_i] = v
    self.backlog_i = self.backlog_i + 1
end

function PIDReactorSteamMode.getAverage(self)
    local sum = 0

    for _, v in pairs(self.backlog) do
        sum = sum + v
    end

    return sum / #self.backlog
end

return PIDReactorSteamMode
