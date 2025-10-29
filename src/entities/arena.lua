-- arena.lua
-- game arena with three walls (left, top, right)
-- bottom is open for out-of-bounds
Arena = {}
Arena.__index = Arena

setmetatable(Arena, {__index = Entity})


function Arena.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0
    })

    setmetatable(self, Arena)

    self.w = opts.width or 128
    self.h = opts.height or 128
    self.wall_thickness = opts.wall_thickness or 2
    self.color = opts.color or 7

    return self
end

function Arena:draw()
    local t = self.wall_thickness - 1
    
    -- Left wall
    rectfill(self.x, self.y, self.x + t, self.y + self.h, self.color)
    
    -- Top wall
    rectfill(self.x, self.y, self.x + self.w - 1, self.y + t, self.color)
    
    -- Right wall
    rectfill(self.x + self.w - 1 - t, self.y, self.x + self.w - 1, self.y + self.h, self.color)
    
    -- Bottom is open (no wall)
end
