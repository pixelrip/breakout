-- player.lua
-- player entity with paddle control

Player = {}
Player.__index = Player

setmetatable(Player, {__index = Entity})

Player.DEBUG = true

function Player.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 120,
    })

    setmetatable(self, Player)
    
    self.idx = opts.idx or 0

    self.w = opts.w or 24
    self.a = opts.a or 0
    self.color = opts.color or 7
    self.bounce = opts.bounce or 0.2

    -- Movement Defaults
    self.vx = 0
    self.vy = 0
    self.acceleration = opts.acceleration or 0.5
    self.friction = opts.friction or 0.8
    
    -- Hate this name; its a timer for how close the player is to hitting the ball
    self.prox_y1 = 0
    self.prox_y2 = 0

    self:_update_endpoints()
    self:_update_math()
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
    self:_apply_friction()

    -- Update line position/values
    self:_update_endpoints()
    self:_update_math()

    -- Calculate velocity at line endpoints
    self.vy1 = self.y1 - prev_y1
    self.vy2 = self.y2 - prev_y2

    -- Reduce shot timing
    self.prox_y1 = max(0, self.prox_y1 - 1)
    self.prox_y2 = max(0, self.prox_y2 - 1)
end

function Player:draw()
    line(self.x1, self.y1, self.x2, self.y2, self.color)
    pset(self.x, self.y, 8)

    -- DEBUG
    --[[
    if self.DEBUG then
        print("x: ", 3, 3, 7)
        print(self.x, 40 * (self.idx + 1), 3, 7)
        print("y: ", 3, 9, 7)
        print(self.y, 40 * (self.idx + 1), 9, 7)
        print("prox_y1: ", 3, 15, 7)
        print(self.prox_y1, 40 * (self.idx + 1), 15, 7)
        print("prox_y2: ", 3, 21, 7)
        print(self.prox_y2, 40 * (self.idx + 1), 21, 7)
        print("pop: ", 3, 27, 7)
        print(self.debug_pop, 40 * (self.idx + 1), 27, 7)
        print("vop: ", 3, 33, 7)
        print(self.debug_vop, 40 * (self.idx + 1), 33, 7)
        print("prox: ", 3, 39, 7)
        print(self.debug_prox, 40 * (self.idx + 1), 39, 7)
    end
    ]]--
end


-- "Private" Methods

function Player:_update_endpoints()
    -- token saver for duplicate _init and _update code
    local hw = self.w / 2
    local dx = cos(self.a) * hw
    local dy = sin(self.a) * hw

    self.x1 = self.x - dx
    self.y1 = self.y - dy
    self.x2 = self.x + dx
    self.y2 = self.y + dy
end

function Player:_update_math()
    self.lowest_y = max(self.y1, self.y2)
    self.m = get_slope(self.x1, self.y1, self.x2, self.y2)
    self.c = get_y_intercept(self.m, self.x1, self.y1)
end

function Player:_apply_friction()
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
end

function Player:_controller_inputs()
    local up = input:onhold(2, self)
    local down = input:onhold(3, self)
    local left = input:onhold(0, self)
    local right = input:onhold(1, self)
    local o_held = input:onhold(4, self)
    local x_held = input:onhold(5, self)
    local o_onpress = input:onpress(4, self)
    local x_onpress = input:onpress(5, self)

    -- Joystick movement
    if left then self.vx -= self.acceleration end
    if right then self.vx += self.acceleration end
    if up then self.vy -= self.acceleration end
    if down then self.vy += self.acceleration end

    if o_onpress and not x_held then
        self.prox_y1 = 5
    elseif x_onpress and not o_held then
        self.prox_y2 = 5
    end

    -- Buttons for tilting the paddle
     if o_held and not x then
        self.a = max(self.a - 0.05, -0.125)
    elseif x_held and not o_held then
        self.a = min(self.a + 0.05, 0.125)
    else
        self.a = 0
   end
end

function Player:get_boosh(b)
    -- "Boosh" is a factor of how hard the
    -- player hits the ball based on where
    -- the ball collided with the paddle as 
    -- well as their timing (prox) with the "swing"


    -- Position on paddle (0 -> 1)
    local pop = (b.x - self.x1) / (self.x2 - self.x1)
    self.debug_pop = pop

    -- Velocity at that `pop`
    local vop = self.vy1 + pop * (self.vy2 - self.vy1)
    self.debug_vop = vop

    -- Timing the "swing"
    local prox = pop < 0.5 and self.prox_y1 or self.prox_y2
    self.debug_prox = prox

    -- boosh = velocity at point minus timing factor plus some of player's velocity
    return vop - (prox * 0.5) + (self.vy * 0.5)
end