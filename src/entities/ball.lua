-- ball.lua
-- ball with pinball physics
Ball = {}
Ball.__index = Ball

setmetatable(Ball, {__index = Entity})

function Ball.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 10,
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
        local hit, hit_pos = circle_vs_line(self, p)
        if hit then
            self:_on_player_collision(p, hit_pos)
        end
    end

    -- Check wall collisions - find earliest collision
    local earliest_collision = nil
    local earliest_wall = nil
    local earliest_t = 999

    for w in all(world.walls) do
        local hit, collision_info = box_vs_box(self, w)
        if hit and collision_info and collision_info.t < earliest_t then
            earliest_t = collision_info.t
            earliest_collision = collision_info
            earliest_wall = w
        end
    end

    -- Handle only the first collision
    if earliest_collision then
        self:_on_wall_collision(earliest_wall, earliest_collision)
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

function Ball:_on_player_collision(p, h)

    local boosh = p:get_boosh(self)

    -- Correct Position
    self.x = h.x
    self.y = h.y

    self.vy = self.prev.vy * -p.bounce + boosh * 1 --Tuning factor
    self.vx += p.m * self.prev.vy * 0.5 -- Tuning factor
end

function Ball:_update_bounds()
    self.bounds = {
        top = self.y - self.r,
        bottom = self.y + self.r,
        left = self.x - self.r,
        right = self.x + self.r
    }
end

function Ball:_store_previous_frame_data()
    self.prev = {
        x = self.x,
        y = self.y,
        vx = self.vx,
        vy = self.vy,
        bounds = {
            top = self.bounds.top,
            bottom = self.bounds.bottom,
            left = self.bounds.left,
            right = self.bounds.right
        }
    }
end

--[[
function Ball:_check_wall_collision(bounds)
    if self.left <= bounds.right and
        self.right >= bounds.left and
        self.bottom >= bounds.top and
        self.top <= bounds.bottom then
        return true
    end

    return false
end
]]--

function Ball:_on_wall_collision(w, collision_info)
    -- Handle collision based on collision normal
    -- If collision_info is nil (fallback static collision), use old method
    if not collision_info then
        local ball_bounds = self.bounds
        local wall_bounds = w.bounds

        -- Simple collision response: invert velocity based on side hit
        if self.prev.vy > 0 and ball_bounds.top < wall_bounds.top then
            self.y = wall_bounds.top - self.r
            self.vy = self.prev.vy * -w.bounce
        elseif self.prev.vy < 0 and ball_bounds.bottom > wall_bounds.bottom then
            self.y = wall_bounds.bottom + self.r
            self.vy = self.prev.vy * -w.bounce
        elseif self.vx > 0 and ball_bounds.left < wall_bounds.left then
            self.x = wall_bounds.left - self.r
            self.vx = self.vx * -w.bounce
        elseif self.vx < 0 and ball_bounds.right > wall_bounds.right then
            self.x = wall_bounds.right + self.r
            self.vx = self.vx * -w.bounce
        end
        return
    end

    -- Swept collision response using normals
    local t = collision_info.t

    -- Get ball velocity this frame
    local vel_x = self.x - self.prev.x
    local vel_y = self.y - self.prev.y

    -- Get wall velocity (if moving)
    local wall_vx = collision_info.b_vx or 0
    local wall_vy = collision_info.b_vy or 0

    -- Move to collision point
    self.x = self.prev.x + vel_x * t
    self.y = self.prev.y + vel_y * t

    -- Apply bounce based on collision normal
    if collision_info.normal_x ~= 0 then
        -- Bounce relative velocity and add wall velocity
        local relative_vx = self.vx - wall_vx
        self.vx = relative_vx * -w.bounce + wall_vx
        vel_x = vel_x * -w.bounce + wall_vx
    end

    if collision_info.normal_y ~= 0 then
        -- Bounce relative velocity and add wall velocity
        local relative_vy = self.vy - wall_vy
        self.vy = relative_vy * -w.bounce + wall_vy
        vel_y = vel_y * -w.bounce + wall_vy
    end

    -- Apply remaining motion for (1-t) of the frame
    local remaining = 1 - t
    self.x = self.x + vel_x * remaining
    self.y = self.y + vel_y * remaining

    -- Update bounds after position correction
    self:_update_bounds()
end
