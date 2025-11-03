-- brick.lua

Brick = {}
Brick.__index = Brick

setmetatable(Brick, {__index = Entity})

Brick.DEBUG = true

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
    self.hp = opts.hp or 6
    self.val = opts.val or 1
    self.bounce = opts.bounce or 0.8

    -- Velocity (TBD)
    -- self.vx = 0
    -- self.vy = 0

    self.bounds = get_bounds(self) 

    -- Store previous frame data
    self.prev = {}

    return self
end

function Brick:update()
    -- Store previous frame data
    self:_store_previous_frame_data()

    -- TBD: Moving bricks, animation, etc

    -- Update bounds
    self.bounds = get_bounds(self)
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

    if self.DEBUG then
        print(self.hp, self.x + 1, self.y + 1, 14)
    end
end

function Brick:on_ball_collision(amount)
    self.hp -= amount
    if self.hp <= 0 then
        self:explode()
        game:on_brick_destroyed(self.val)
    end
end

function Brick:explode()
    -- TBD: particle effects, sound, etc 
    if self.hp > 0 then return end

    world:remove(self, "brick")
end

-- "Private" Methods

function Brick:_store_previous_frame_data()
    self.prev = {
        x = self.x,
        y = self.y,
        vx = self.vx,
        vy = self.vy,
        hp = self.hp,
        bounds = self.bounds
    }
end