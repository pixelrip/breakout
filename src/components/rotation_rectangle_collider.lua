RotationRectangleCollider = {}
RotationRectangleCollider.__index = RotationRectangleCollider

RotationRectangleCollider.DEBUG = false

function RotationRectangleCollider.new(owner, opts)
    local self = setmetatable({}, RotationRectangleCollider)

    self.owner = owner
    self.offset = opts.offset or 0
    self.corners = {
        top_left = {},
        top_right = {},
        bottom_right = {},
        bottom_left = {}
    }

    return self
end

function RotationRectangleCollider:update()
    -- Required components
    local rectangle = self.owner:get_component(Rectangle)

    if not rectangle then
        return
    end

    local corners = rectangle.corners
    local tl = corners.top_left
    local tr = corners.top_right
    local br = corners.bottom_right
    local bl = corners.bottom_left

    -- Calculate corners based on rectangle + offset
    -- FIX: should offset be applied differently based on rotation? works for now.
    self.corners.top_left = {
        tl[1] - self.offset,
        tl[2] - self.offset
    }
    self.corners.top_right = {
        tr[1] + self.offset,
        tr[2] - self.offset
    }
    self.corners.bottom_right = {
        br[1] + self.offset,
        br[2] + self.offset 
    }
    self.corners.bottom_left = {
        bl[1] - self.offset,
        bl[2] + self.offset
    }
end

function RotationRectangleCollider:draw()
    if not self.DEBUG then return end
    
    local x = self.owner.x
    local y = self.owner.y

    -- draw the collider using lines between corners
    local tl = self.corners.top_left
    local tr = self.corners.top_right
    local br = self.corners.bottom_right
    local bl = self.corners.bottom_left

    -- draw lines
    line(x + tl[1], y + tl[2], x + tr[1], y + tr[2], 11) -- top edge
    line(x + tr[1], y + tr[2], x + br[1], y + br[2], 11) -- right edge
    line(x + br[1], y + br[2], x + bl[1], y + bl[2], 11) -- bottom edge
    line(x + bl[1], y + bl[2], x + tl[1], y + tl[2], 11) -- left edge
end