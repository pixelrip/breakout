-- paddle.lua
-- player paddle control
Paddle = {}
Paddle.__index = Paddle

-- Tuning Constants
Paddle.W = 24

function Paddle.new(owner, opts)
    -- Base entity
    local self = setmetatable({}, Paddle)

    self.owner = owner

    -- Properties
    -- TODO: DRY?
    local hw = Paddle.W / 2
    self.x1 = owner.x - hw
    self.y1 = owner.y
    self.x2 = owner.x + hw
    self.y2 = owner.y

    self.lowest_y = max(self.y1, self.y2)
    self.tilt_y1 = 0
    self.tilt_y2 = 0

    self.col = opts.col or 7
    self.bounce = opts.bounce or 0.8

    self.m = 0
    self.c = 0

    return self
end

function Paddle:update()
    local prev_y1 = self.y1
	local prev_y2 = self.y2

    -- TODO: DRY?
    local hw = self.W / 2

    self.x1 = self.owner.x - hw
    self.y1 = self.owner.y + self.tilt_y1
    self.x2 = self.owner.x + hw
    self.y2 = self.owner.y + self.tilt_y2

    self.lowest_y = max(self.y1, self.y2)

	self.vy1 = self.y1 - prev_y1
	self.vy2 = self.y2 - prev_y2

    self.lowest_y = max(self.y1, self.y2)
	self.m = get_slope(self.x1, self.y1, self.x2, self.y2)
	self.c = get_y_intercept(self.m, self.x1, self.y1)
end

function Paddle:draw()
    line(self.x1, self.y1, self.x2, self.y2, self.col)
    pset(self.owner.x, self.owner.y, 8)
end
