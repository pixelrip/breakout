-- wall.lua

Wall = {}
Wall.__index = Wall

setmetatable(Wall, {__index = Entity})


function Wall.new(opts)
    -- Base entity
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0
    })

    setmetatable(self, Wall)

    self.w = opts.width or 128
    self.h = opts.height or 128
    self.color = opts.color or 7
    self.bounce = opts.bounce or 0.9

    -- Velocity (for moving walls)
    self.vx = opts.vx or 0
    self.vy = opts.vy or 0

    self:_update_bounds()

    -- Previous frame data
    self.prev = {}

    return self
end

function Wall:update()
    -- Store previous frame data
    self:_store_previous_frame_data()

    -- Apply velocity (for moving walls)
    self.x += self.vx
    self.y += self.vy

    -- Update bounds
    self:_update_bounds()
end

function Wall:draw()
    rrectfill(self.x, self.y, self.w, self.h, 0, self.color)
end

-- "Private" Methods

function Wall:_update_bounds()
    self.bounds = {
        left = self.x,
        right = self.x + self.w - 1,
        top = self.y,
        bottom = self.y + self.h - 1
    }
end

function Wall:_store_previous_frame_data()
    self.prev = {
        x = self.x,
        y = self.y,
        vx = self.vx,
        vy = self.vy,
        bounds = {
            left = self.bounds.left,
            right = self.bounds.right,
            top = self.bounds.top,
            bottom = self.bounds.bottom
        }
    }
end
