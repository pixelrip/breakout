-- Circle Collider Component
-- Handles collisions with circular objects

CircleCollider = {}
CircleCollider.__index = CircleCollider

CircleCollider.DEBUG = false

function CircleCollider.new(owner, opts)
    local self = setmetatable({}, CircleCollider)
    self.owner = owner
    
    -- Properties
    self.r = opts.r or 2

    return self
end

function CircleCollider:draw()
    if not self.DEBUG then return end
    circ(self.owner.x, self.owner.y, self.r, 10)
end