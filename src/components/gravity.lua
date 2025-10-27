-- Gravity Component
-- Applies constant downward acceleration for pinball physics

Gravity = {}
Gravity.__index = Gravity

function Gravity.new(owner, opts)
    local self = setmetatable({}, Gravity)
    self.owner = owner
    
    -- Properties
    self.gravity_strength = opts.gravity_strength or 0.15

    return self
end

function Gravity:update()
    -- Required components
    local mover = self.owner:get_component(Mover)

    -- Apply gravity to vertical velocity
    mover.vy += self.gravity_strength
end
