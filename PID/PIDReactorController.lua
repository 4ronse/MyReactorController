local PIDSteamReactor = {}

function PIDSteamReactor.new(reactor, pidController, targetHotFluidProduction)
    local self                    = setmetatable({}, { __index = PIDSteamReactor })

    self.reactor                  = reactor
    self.pid                      = pidController

    self.targetHotFluidProduction = targetHotFluidProduction or 2000

    self.maxControlRodLevel       = 100
    self.minControlRodLevel       = 0

    return self
end

function PIDSteamReactor:setTargetHotFluidProduction(t)
    self.targetHotFluidProduction = t
end

function PIDSteamReactor:controlReactor()
    -- Activate reactor
    self.reactor.setActive(true)

    local hotFluidLT = self.reactor:getHotFluidProducedLastTick()
    local output = self.pid:calculateOutput(self.targetHotFluidProduction, hotFluidLT)

    -- Adjust control rod level based on PID output
    local currentControlRodLevel = self.reactor.getControlRodLevel(0)
    local newControlRodLevel = currentControlRodLevel + output

    -- Ensure control rod level is within bounds
    newControlRodLevel = math.max(self.minControlRodLevel, math.min(self.maxControlRodLevel, newControlRodLevel))

    print("hotFluidLastTick: " .. tostring(hotFluidLT) .. "mb")
    print("PID Output: " .. tostring(output))
    print("Control Rod Level: " .. tostring(currentControlRodLevel) .. " -> " .. tostring(newControlRodLevel))

    -- Set the new control rod level
    self.reactor:setAllControlRodLevels(newControlRodLevel)
end

function PIDSteamReactor:__tostring()
    return string.format("PID Steam Reactor: Target Hot Fluid Production=%d, %s", self.targetHotFluidProduction,
        tostring(self.pid))
end

return PIDSteamReactor
