-- ball.lua
-- ball with pinball physics
Ball = {}
Ball.__index = Ball

setmetatable(Ball, {__index = Entity})

function Ball.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 60,
    })

    setmetatable(self, Ball)

    -- Ball properties
    self.vx = 0
    self.vy = 0
    self.r = opts.r or 2
    
    self:_update_bounds()

    self.color = opts.color or 7
    self.gravity = opts.gravity or 0.2

    return self
end


function Ball:update()
    local prev_vy = self.vy

    -- apply gravity
    self.vy += self.gravity

    -- apply velocity to position
    self.x += self.vx
    self.y += self.vy

    -- update bounds
    self:_update_bounds()

    -- TODO: check paddle collision
end

function Ball:draw()
    circfill(self.x, self.y, self.r, self.color)
    pset(self.x, self.y, 8)
end

function Ball:on_paddle_collision(paddle, py)
    local mover = self:get_component(Mover)
    local circle = self:get_component(Circle)

    local _prev_vy = mover.vy

    -- Correct position
    self.y = py - circle.radius

    -- Invert y velocity with bounce factor
    mover.vy = _prev_vy * -paddle.bounce * 0.9 -- Tuning factor
    mover.vx += paddle.m * _prev_vy * 0.5 -- Tuning factor
    
    
    --[[
    -- Calculate velocity at the balls x position on the platform
    local t = (self.x - platform.x1) / (platform.x2 - platform.x1)
    local platform_vy_at_ball = platform.vy1 + t * (platform.vy2 - platform.vy1)

    -- Correct Position
    self.y = platform_y_at_ball - self.r

    -- simple collision response: invert y velocity
    self.vy = _prev_vy * -platform.bounce + platform_vy_at_ball * 0.5 --Tuning factor

    self.vx += platform.m * _prev_vy * 0.5 -- Tuning factor
    ]]--
end


function Ball:_update_bounds()
    self.bottom = self.y + self.r
    self.top = self.y - self.r
    self.left = self.x - self.r
    self.right = self.x + self.r
end