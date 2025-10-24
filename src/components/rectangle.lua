-- Rectangle
-- Component for drawing a rectangle at any angle

Rectangle = {}
Rectangle.__index = Rectangle

Rectangle.DEBUG = false

function Rectangle.new(owner, opts)
    local self = setmetatable({}, Rectangle)

    self.owner = owner
    self.angle = opts.angle or 0
    self.color = opts.color or 7
    self.corners = {
        top_left = {}, -- top-left
        top_right = {}, -- top-right
        bottom_right = {}, -- bottom-right
        bottom_left = {}  -- bottom-left
    }

    return self
end

function Rectangle:update()
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

    -- update corner positions
    self.corners.top_left = {-v1x - v2x, -v1y - v2y} -- top-left
    self.corners.top_right = { v1x - v2x,  v1y - v2y} -- top-right
    self.corners.bottom_right = { v1x + v2x,  v1y + v2y} -- bottom-right
    self.corners.bottom_left = {-v1x + v2x, -v1y + v2y} -- bottom-left

end

function Rectangle:draw()
    local x = self.owner.x
    local y = self.owner.y

    -- draw the rectangle using lines between corners
    local tl = self.corners.top_left
    local tr = self.corners.top_right
    local br = self.corners.bottom_right
    local bl = self.corners.bottom_left

    -- draw lines
    line(x + tl[1], y + tl[2], x + tr[1], y + tr[2], self.color) -- top edge
    line(x + tr[1], y + tr[2], x + br[1], y + br[2], self.color) -- right edge
    line(x + br[1], y + br[2], x + bl[1], y + bl[2], self.color) -- bottom edge
    line(x + bl[1], y + bl[2], x + tl[1], y + tl[2], self.color) -- left edge

    -- draw corners for debugging
    if self.DEBUG then 
        pset(x + tl[1], y + tl[2], 8) -- top-left
        pset(x + tr[1], y + tr[2], 9) -- top-right
        pset(x + br[1], y + br[2], 10) -- bottom-right
        pset(x + bl[1], y + bl[2], 11) -- bottom-left
    end
end
