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

    -- Previous frame data
    self.prev = {}

    return self
end


function Ball:update()
    -- store previous frame data
    self:_store_previous_frame_data()

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

    -- Check wall collisions
    for w in all(world.walls) do
        if self:_check_wall_collision(w.bounds) then
            self:_on_wall_collision(w)
        end
    end

    -- DEBUG: Return ball if off screen
    if self.y  > 200 then
        self.y = 20
        self.x = 64
        self.vy = 0
        self.vx = 0
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

    local boosh = p:get_boosh(self)

    -- Correct Position
    self.y = py - self.r

    -- simple collision response: invert y velocity
    self.vy = self.prev.vy * -p.bounce + boosh * 1 --Tuning factor
    self.vx += p.m * self.prev.vy * 0.5 -- Tuning factor
end

function Ball:_update_bounds()
    self.bottom = self.y + self.r
    self.top = self.y - self.r
    self.left = self.x - self.r
    self.right = self.x + self.r
end

function Ball:_store_previous_frame_data()
    self.prev = {
        x = self.x,
        y = self.y,
        vx = self.vx,
        vy = self.vy,
        top = self.top,
        bottom = self.bottom,
        left = self.left,
        right = self.right
    }
end

function Ball:_check_wall_collision(bounds)
    if self.left <= bounds.right and
        self.right >= bounds.left and
        self.bottom >= bounds.top and
        self.top <= bounds.bottom then
        return true
    end

    return false
end

function Ball:_on_wall_collision(w)
    -- Simple collision response: invert velocity based on side hit
    if self.prev.vy > 0 and self.top < w.bounds.top then
        -- Hit from top
        self.y = w.bounds.top - self.r
        self.vy = self.prev.vy * -w.bounce
    elseif self.prev.vy < 0 and self.bottom > w.bounds.bottom then
        -- Hit from bottom
        self.y = w.bounds.bottom + self.r
        self.vy = self.prev.vy * -w.bounce
    elseif self.vx > 0 and self.left < w.bounds.left then
        -- Hit from left
        self.x = w.bounds.left - self.r
        self.vx = self.vx * -w.bounce
    elseif self.vx < 0 and self.right > w.bounds.right then
        -- Hit from right
        self.x = w.bounds.right + self.r
        self.vx = self.vx * -w.bounce
    end
end