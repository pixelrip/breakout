-- ball.lua
-- ball with pinball physics
Ball = {}
Ball.__index = Ball

setmetatable(Ball, {__index = Entity})

-- Tuning Constants
Ball.RADIUS = 2
Ball.GRAVITY = 0.15
Ball.FRICTION = 0.02
Ball.MAX_SPEED = 4

function Ball.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 60,
        w = Ball.RADIUS * 2,
        h = Ball.RADIUS * 2
    })

    setmetatable(self, Ball)
        
    -- compose behavior with components
    self:add_component(Mover.new(self, {
        vx = opts.vx or 0,
        vy = opts.vy or 0,
        max_speed = Ball.MAX_SPEED,
        friction = Ball.FRICTION
    }))
    self:add_component(Gravity.new(self, {
        gravity_strength = Ball.GRAVITY
    }))
    self:add_component(Circle.new(self, {
        radius = Ball.RADIUS,
        color = 7
    }))
    self:add_component(CircleCollider.new(self, {
        r = Ball.RADIUS + 2
    }))

    return self
end
