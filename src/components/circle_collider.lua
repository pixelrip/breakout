-- Circle Collider Component
-- Handles collisions with circular objects

CircleCollider = {}
CircleCollider.__index = CircleCollider

function CircleCollider.new(owner, opts)
    local self = setmetatable({}, CircleCollider)
    self.owner = owner
    
    -- Properties
    self.r = opts.r or 2

    return self
end

