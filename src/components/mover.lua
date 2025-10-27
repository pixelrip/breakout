-- Mover Component
-- Handles velocity-based movement with physics (friction, max speed)

Mover = {}
Mover.__index = Mover

function Mover.new(owner, opts)
    local self = setmetatable({}, Mover)
    self.owner = owner
    
    -- Properties
    self.vx = opts.vx or 0
    self.vy = opts.vy or 0
    self.max_speed = opts.max_speed or 2
    self.friction = opts.friction or 0.1

    return self
end

function Mover:update()
    -- Apply velocity to position
    self.owner.x += self.vx
    self.owner.y += self.vy

    -- Apply friction to vx
    if self.vx > 0 then
        self.vx = max(0, self.vx - self.friction)
    elseif self.vx < 0 then
        self.vx = min(0, self.vx + self.friction)
    end

    -- Apply friction to vy
    if self.vy > 0 then
        self.vy = max(0, self.vy - self.friction)
    elseif self.vy < 0 then
        self.vy = min(0, self.vy + self.friction)
    end

    -- Clamp to max_speed
    self.vx = mid(-self.max_speed, self.vx, self.max_speed)
    self.vy = mid(-self.max_speed, self.vy, self.max_speed)
end
