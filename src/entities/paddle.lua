-- paddle.lua
-- player paddle control
Paddle = {}
Paddle.__index = Paddle

setmetatable(Paddle,{__index = Entity})

-- Tuning Constants
Paddle.W = 28
Paddle.H = 4
Paddle.MAX_ANGLE = 0.08 -- max angle
Paddle.ROTATION_SPEED = 0.01 -- 0.01
Paddle.SNAP_SPEED = 0.04
Paddle.ACCELERATION = 0.5
Paddle.MAX_SPEED = 2
Paddle.FRICTION = 0.1


function Paddle.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 0,
        y = opts.y or 0,
        w = Paddle.W,
        h = Paddle.H
    })

    setmetatable(self, Paddle)
        
    -- compose behavior with components
    self:add_component(Rotation.new(self,{
        angle = 0
    }))
    self:add_component(Rectangle.new(self, {
        color = 7
    }))
    self:add_component(Mover.new(self, {
        vx = 0,
        vy = 0,
        max_speed = Paddle.MAX_SPEED,
        friction = Paddle.FRICTION
    }))
    self:add_component(InputMover.new(self, {
        acceleration = Paddle.ACCELERATION
    }))
    self:add_component(InputRotater.new(self, {
        max_angle = Paddle.MAX_ANGLE,
        rotation_speed = Paddle.ROTATION_SPEED,
        snap_speed = Paddle.SNAP_SPEED
    }))

    return self
end