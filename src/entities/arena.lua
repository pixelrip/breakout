-- arena.lua
-- game arena with three walls (left, top, right)
-- bottom is open for out-of-bounds
Arena = {}
Arena.__index = Arena

setmetatable(Arena, {__index = Entity})

-- Tuning Constants
Arena.X = 0
Arena.Y = 0
Arena.WIDTH = 128
Arena.HEIGHT = 128
Arena.WALL_THICKNESS = 2
Arena.COLOR = 7

function Arena.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or Arena.X,
        y = opts.y or Arena.Y,
        w = opts.width or Arena.WIDTH,
        h = opts.height or Arena.HEIGHT
    })

    setmetatable(self, Arena)
    
    self.wall_thickness = opts.wall_thickness or Arena.WALL_THICKNESS
    self.color = opts.color or Arena.COLOR

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
