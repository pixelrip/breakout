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
    
    self.color = opts.color or 7
    self.gravity = opts.gravity or 0.1
    
    self:_update_bounds()

    return self
end


function Ball:update()
    self.prev_vy = self.vy

    -- apply gravity
    self.vy += self.gravity

    -- apply velocity to position
    self.x += self.vx
    self.y += self.vy

    -- update bounds
    self:_update_bounds()

    -- Check paddle collision
    for p in all(world.players) do
        local py = self:_check_paddle_collision(p)
        if py then
            self:_on_paddle_collision(p, py)
        end
    end
end

function Ball:draw()
    circfill(self.x, self.y, self.r, self.color)
    pset(self.x, self.y, 8)
end

-- "Private" Methods

function Ball:_check_paddle_collision(p)
    -- FIX: Definite tunneling issues at high speeds

    local paddle_y_at_ball = (p.m * self.x) + p.c

	if self.bottom >= paddle_y_at_ball and
		self.top <= p.lowest_y + abs(self.vy) + 2 and
		self.x >= p.x1 and
		self.x <= p.x2 then
		return paddle_y_at_ball
	end

	return false
end

function Ball:_on_paddle_collision(p, py)
    -- Calculate velocity at the balls x position on the platform
    local t = (self.x - p.x1) / (p.x2 - p.x1)
    local p_vy_at_ball = p.vy1 + t * (p.vy2 - p.vy1)

    -- Correct Position
    self.y = py - self.r

    -- simple collision response: invert y velocity
    self.vy = self.prev_vy * -p.bounce + p_vy_at_ball * 0.5 --Tuning factor

    self.vx += p.m * self.prev_vy * 0.5 -- Tuning factor
end

function Ball:_update_bounds()
    self.bottom = self.y + self.r
    self.top = self.y - self.r
    self.left = self.x - self.r
    self.right = self.x + self.r
end