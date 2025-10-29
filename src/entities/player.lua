-- player.lua
-- player entity with paddle control

Player = {}
Player.__index = Player

setmetatable(Player, {__index = Entity})

function Player.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 120,
    })

    setmetatable(self, Player)
    
    self.idx = opts.idx or 0

    self.w = opts.w or 24

    self.vx = 0
    self.vy = 0

    self.max_v = opts.max_v or 3
    self.acceleration = opts.acceleration or 0.5
    self.friction = opts.friction or 0.8
    
    self.tilt_y1 = 0
    self.tilt_y2 = 0
    
    self:_update_line()

    self.color = opts.color or 7
    self.bounce = opts.bounce or 0.8

    return self
end

function Player:update()
    local prev_y1 = self.y1
    local prev_y2 = self.y2
    
    -- Check for player input
    self:_controller_inputs()

    -- Apply velocity to position
    self.x += self.vx
    self.y += self.vy

    -- Apply friction
    if self.vx >  0 then
        self.vx = max(0, self.vx * self.friction)
    elseif self.vx < 0 then
        self.vx = min(0, self.vx * self.friction)
    end

    if self.vy >  0 then
        self.vy = max(0, self.vy * self.friction)
    elseif self.vy < 0 then
        self.vy = min(0, self.vy * self.friction)
    end

    -- Update line position/values
    self:_update_line()

    -- Calculate velocity at line endpoints
    self.vy1 = self.y1 - prev_y1
    self.vy2 = self.y2 - prev_y2

end

function Player:draw()
    line(self.x1, self.y1, self.x2, self.y2, self.color)
    pset(self.x, self.y, 8)
end


-- "Private" Methods

function Player:_update_line()
    -- token saver for duplicate _init and _update code
    local hw = self.w / 2

    self.x1 = self.x - hw
    self.y1 = self.y + self.tilt_y1
    self.x2 = self.x + hw
    self.y2 = self.y + self.tilt_y2

    self.lowest_y = max(self.y1, self.y2)
	self.m = get_slope(self.x1, self.y1, self.x2, self.y2)
	self.c = get_y_intercept(self.m, self.x1, self.y1)
end

function Player:_controller_inputs()
    local idx = self.idx
    local up = btn(2, idx)
    local down = btn(3, idx)
    local left = btn(0, idx)
    local right = btn(1, idx)
    local o = btn(4, idx)
    local x = btn(5, idx)

    -- Joystick movement
    if left then 
        self.vx -= self.acceleration
        self.vx = max(self.vx, -self.max_v)
    end
    if right then 
        self.vx += self.acceleration
        self.vx = min(self.vx, self.max_v)
    end
    if up then 
        self.vy -= self.acceleration 
        self.vy = max(self.vy, -self.max_v)
    end
    if down then 
        self.vy += self.acceleration 
        self.vy = min(self.vy, self.max_v)
    end

    -- Buttons for tilting the paddle
     if o and not x then
        self.tilt_y1 = 6
        self.tilt_y2 = -6
    elseif x and not o then
        self.tilt_y1 = -6
        self.tilt_y2 = 6
    else
        self.tilt_y1 = 0
        self.tilt_y2 = 0  
   end
end