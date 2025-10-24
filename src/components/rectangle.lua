-- Rectangle
-- Component for drawing a rectangle at any angle

Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle.new(owner, opts)
    local self = setmetatable({}, Rectangle)

    self.owner = owner
    self.angle = opts.angle or 0
    self.color = opts.color or 7

    return self
end

function Rectangle:draw()

    -- Gets rotation compnent; fallback if there is not one
    local rotation = self.owner:get_component(Rotation)
    local angle = 0

    if rotation != nil then
        angle = rotation.angle
    end

    local hw = self.owner.w / 2 -- half-width
    local hh = self.owner.h / 2 -- half-height
    
    -- pre-calculate sin/cos
    -- rotation.angle is in PICO-8's 0-1 format
    local c = cos(angle)
    local s = sin(angle)

    -- calculate the 4 corner vectors
    local v1x, v1y = hw*c, hw*s
    local v2x, v2y = -hh*s, hh*c

    -- calculate the 4 absolute corner positions
    local x1 = self.owner.x - v1x + v2x
    local y1 = self.owner.y - v1y + v2y
    local x2 = self.owner.x + v1x + v2x
    local y2 = self.owner.y + v1y + v2y
    local x3 = self.owner.x + v1x - v2x
    local y3 = self.owner.y + v1y - v2y
    local x4 = self.owner.x - v1x - v2x
    local y4 = self.owner.y - v1y - v2y

    -- draw the 4 lines connecting the corners
    -- this draws a hollow rect
    line(x1, y1, x2, y2, self.color)
    line(x2, y2, x3, y3, self.color)
    line(x3, y3, x4, y4, self.color)
    line(x4, y4, x1, y1, self.color)
end
