local PIDController = {}

function PIDController.new(kp, ki, kd)
    local self = setmetatable({}, { __index = PIDController })

    self.kp = kp or 0
    self.ki = ki or 0
    self.kd = kd or 0

    self.integral = 0
    self.prevError = 0

    return self
end

function PIDController:setGains(kp, ki, kd)
    self.kp = kp
    self.ki = ki
    self.kd = kd
end

function PIDController:calculateOutput(sp, pv)
    local error = sp - pv
    self.integral = self.integral + error

    local derivative = error - self.prevError
    local output = self.kp * error + self.ki * self.integral + self.kd * derivative

    self.prevError = error

    return output
end

function PIDController:__tostring()
    return string.format("PID Controller: kp=%.3f, ki=%.3f, kd=%.3f", self.kp, self.ki, self.kd)
end

return PIDController
