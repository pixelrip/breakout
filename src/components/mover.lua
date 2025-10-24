-- Mover Component
-- Handles velocity-based movement with physics (friction, max speed)

Mover = {}
Mover.__index = Mover

function Mover.new(owner, opts)
    local self = setmetatable({}, Mover)
    self.owner = owner
    
    -- Properties
    self.dx = opts.dx or 0
    self.dy = opts.dy or 0
    self.max_speed = opts.max_speed or 2
    self.friction = opts.friction or 0.1

    return self
end

function Mover:update()
    -- Apply velocity to position
    self.owner.x += self.dx
    self.owner.y += self.dy

    -- Apply friction to dx
    if self.dx > 0 then
        self.dx = max(0, self.dx - self.friction)
    elseif self.dx < 0 then
        self.dx = min(0, self.dx + self.friction)
    end

    -- Apply friction to dy
    if self.dy > 0 then
        self.dy = max(0, self.dy - self.friction)
    elseif self.dy < 0 then
        self.dy = min(0, self.dy + self.friction)
    end

    -- Clamp to max_speed
    self.dx = mid(-self.max_speed, self.dx, self.max_speed)
    self.dy = mid(-self.max_speed, self.dy, self.max_speed)
end
