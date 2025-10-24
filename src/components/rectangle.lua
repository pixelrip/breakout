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
    local bl_x = self.owner.x - v1x + v2x
    local bl_y = self.owner.y - v1y + v2y
    local br_x = self.owner.x + v1x + v2x
    local br_y = self.owner.y + v1y + v2y
    local tr_x = self.owner.x + v1x - v2x
    local tr_y = self.owner.y + v1y - v2y
    local tl_x = self.owner.x - v1x - v2x
    local tl_y = self.owner.y - v1y - v2y

    -- draw the 4 lines connecting the corners
    -- this draws a hollow rect
    line(tr_x, tr_y, tl_x, tl_y, self.color) -- top
    line(br_x, br_y, tr_x, tr_y, self.color) -- right
    line(bl_x, bl_y, br_x, br_y, self.color) -- bottom
    line(tl_x, tl_y, bl_x, bl_y, self.color) -- left

    pset(tl_x, tl_y, 8) -- top left
    pset(tr_x, tr_y, 9) -- top right
    pset(br_x, br_y, 10) -- bottom right
    pset(bl_x, bl_y, 11) -- bottom left
end
