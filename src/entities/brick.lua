-- brick.lua

Brick = {}
Brick.__index = Brick

setmetatable(Brick, {__index = Entity})

Brick.DEBUG = false

function Brick.new(opts)
    -- Base entity
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0
    })

    setmetatable(self, Brick)

    self.w = opts.width or 10
    self.h = opts.height or 5
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
    local x1 = self.x
    local x2 = self.x + self.w - 1
    local y1 = self.y
    local y2 = self.y + self.h - 1

    local c1, c2, c3 = self:get_colors_for_hp()

    rectfill(x1, y1, x2, y2, c1)
    rectfill(x1 + 1, y1 + 1, x2, y2, c2)
    line(x2, y1, x2, y2, c3)
    line(x1, y2, x2, y2, c3)

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

function Brick:get_colors_for_hp()
    local hp = self.hp
    local c1, c2, c3 = 0, 0, 0

    -- FIX: Magic numbers; smelly code
    if hp == 6 then
        c1 = get_color("white")
        c2 = get_color("p1")
        c3 = get_color("p2")
    elseif hp >= 4 then
        c1 = get_color("p1")
        c2 = get_color("p2")
        c3 = get_color("p3")
    elseif hp > 2 then
        c1 = get_color("p2")
        c2 = get_color("p3")
        c3 = get_color("p4")
    else
        c1 = get_color("p3")
        c2 = get_color("p4")
        c3 = get_color("p5")
    end
    
    return c1, c2, c3
end