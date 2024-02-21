local PID = {}

function PID.new(Kp, Ki, Kd, bounds)
    local self = setmetatable({}, { __index = PID })

    self.Kp = Kp
    self.Ki = Ki
    self.Kd = Kd

    self.integration = 0
    self.last_error = 0

    self.bounds = bounds or { 0, 100 }

    return self
end

function PID.setGains(self, Kp, Ki, Kd)
    self.Kp = Kp
    self.Ki = Ki
    self.Kd = Kd
end

function PID.clamp(self, v --[[Number]])
    local lower = self.bounds[1] -- Change index from 0 to 1
    local upper = self.bounds[2] -- Change index from 0 to 1

    if v < lower then
        return lower
    elseif v > upper then
        return upper
    else
        return v
    end
end

function PID.calc(self, target --[[number]], current --[[number]], dt --[[number]])
    local error = target - current
    self.integration = self.integration + error * dt
    local derivative = 0

    if dt ~= 0 then
        derivative = (error - self.last_error) / dt
    end

    return self:clamp(
        (self.Kp * error)
        + (self.Ki * self.integration)
        + (self.Kd * derivative)
    )
end

return PID
