-- brick.lua

Brick = {}
Brick.__index = Brick

setmetatable(Brick, {__index = Entity})

function Brick.new(opts)
    -- Base entity
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0
    })

    setmetatable(self, Brick)

    self.w = opts.width or 10
    self.h = opts.height or 5
    self.color = opts.color or {7,6}
    self.hp = opts.hp or 1
    self.bounce = opts.bounce or 0.8

    -- Velocity (TBD)
    -- self.vx = 0
    -- self.vy = 0

    self.bounds = get_bounds(self) 

    -- TODO: Do I need this?
    -- self.prev = {}

    return self
end

function Brick:draw()
    local col_primary = self.color[1]
    local col_secondary = self.color[2] or col_primary
    local bx1 = self.x + 1
    local x2 = self.x + self.w - 1
    local by = self.y + self.h - 1
    local ty1 = self.y + 1
    local ty2 = self.y + self.h - 2

    rrect(self.x, self.y, self.w, self.h, 0, col_primary)
    line(bx1, by, x2, by, col_secondary)
    line(x2, ty1, x2, ty2, col_secondary)
end