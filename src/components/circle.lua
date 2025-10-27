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

    self.top = owner.y - self.radius
    self.bottom = owner.y + self.radius
    self.left = owner.x - self.radius
    self.right = owner.x + self.radius

    return self
end

function Circle:update()
    -- Update bounding box
    self.top = self.owner.y - self.radius
    self.bottom = self.owner.y + self.radius
    self.left = self.owner.x - self.radius
    self.right = self.owner.x + self.radius
end

function Circle:draw()
    circfill(self.owner.x, self.owner.y, self.radius, self.color)
end
