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

    self.bounds = {
        left = self.x,
        right = self.x + self.w - 1,
        top = self.y,
        bottom = self.y + self.h - 1
    }

    return self
end

function Wall:draw()  
    rrectfill(self.x, self.y, self.w, self.h, 0, self.color)
end
