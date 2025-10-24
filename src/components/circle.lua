-- Circle Component
-- Draws a filled circle

Circle = {}
Circle.__index = Circle

function Circle.new(owner, opts)
    local self = setmetatable({}, Circle)
    self.owner = owner
    
    -- Properties
    self.radius = opts.radius or 2
    self.color = opts.color or 7

    return self
end

function Circle:draw()
    circfill(self.owner.x, self.owner.y, self.radius, self.color)
end
