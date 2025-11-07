-- ball.lua
-- ball with pinball physics
Ball = {}
Ball.__index = Ball

setmetatable(Ball, {__index = Entity})

Ball.DEBUG = true

function Ball.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 64,
    })

    setmetatable(self, Ball)

    -- Ball properties
    self.vx = 0
    self.vy = 0
    self.r = opts.r or 2
    
    self.color = get_color("white")
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

    -- Check player collision
    local player, hit_pos = self:_check_player_collisions()
    if player then
        self:handle_player_collision(player, hit_pos)
        player:handle_ball_collision(self)
    end

    -- Check wall and brick collisions (find earliest)
    local obj, collision_info, obj_type = self:_check_box_collisions()
    if obj then
        if obj_type == "brick" then
            self:handle_brick_collision(obj, collision_info)
        elseif obj_type == "wall" then
            self:handle_wall_collision(obj, collision_info)
        end
    end

    -- DEBUG: Return ball if off screen
    if self.y  > 200 then
        self.y = 64
        self.x = 64
        self.vy = 0
        self.vx = 0
    end
end


function Ball:draw()
    circfill(self.x, self.y, self.r, self.color)
    pset(self.x, self.y, 8)

    if self.DEBUG then
        print(self:_get_speed(), 2, 122, 7)
    end
end

-- "Private" Methods

function Ball:handle_player_collision(p, h)

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

function Ball:_check_player_collisions()
    for p in all(world.players) do
        local hit, hit_pos = circle_vs_line(self, p)
        if hit then
            return p, hit_pos
        end
    end
    return nil, nil
end

function Ball:_check_box_collisions()
    local earliest_collision = nil
    local earliest_obj = nil
    local earliest_t = 999
    local obj_type = nil

    -- Check walls
    for w in all(world.walls) do
        local hit, collision_info = box_vs_box(self, w)
        if hit and collision_info and collision_info.t < earliest_t then
            earliest_t = collision_info.t
            earliest_collision = collision_info
            earliest_obj = w
            obj_type = "wall"
        end
    end

    -- Check bricks
    for b in all(world.bricks) do
        local hit, collision_info = box_vs_box(self, b)
        if hit and collision_info and collision_info.t < earliest_t then
            earliest_t = collision_info.t
            earliest_collision = collision_info
            earliest_obj = b
            obj_type = "brick"
        end
    end

    return earliest_obj, earliest_collision, obj_type
end




function Ball:handle_wall_collision(w, collision_info)
    self:_apply_box_collision(w, collision_info)
end

function Ball:handle_brick_collision(brick, collision_info)
    -- Apply collision physics (same as wall)

    if self:_get_speed() > 6 then
        self:_apply_box_destruction(brick, collision_info)
    else
        self:_apply_box_collision(brick, collision_info)
    end

    brick:on_ball_collision(self:_calculate_damage())
end

function Ball:_apply_box_destruction(obj, collision_info)
    -- Fast ball passes through brick with slight velocity reduction
    if not collision_info then
        -- Fallback: no CCD data, just reduce velocity
        self.vx *= 0.85
        self.vy *= 0.85
        return
    end

    -- Use CCD collision time to ensure proper positioning
    local t = collision_info.t

    -- Get ball velocity this frame
    local vel_x = self.x - self.prev.x
    local vel_y = self.y - self.prev.y

    -- Move to collision point
    self.x = self.prev.x + vel_x * t
    self.y = self.prev.y + vel_y * t

    -- Reduce velocity slightly (no bounce, just friction/drag)
    local speed_retention = 0.95 -- Tuning factor: retain 85% of speed
    self.vx *= speed_retention
    self.vy *= speed_retention
    vel_x *= speed_retention
    vel_y *= speed_retention

    -- Continue with remaining motion (no direction change)
    local remaining = 1 - t
    self.x = self.x + vel_x * remaining
    self.y = self.y + vel_y * remaining

    -- Update bounds after position update
    self:_update_bounds()
end

-- Shared collision response for box collisions (walls/bricks)
function Ball:_apply_box_collision(obj, collision_info)
    -- Handle collision based on collision normal
    -- If collision_info is nil (fallback static collision), use old method
    if not collision_info then
        local ball_bounds = self.bounds
        local obj_bounds = obj.bounds

        -- Simple collision response: invert velocity based on side hit
        if self.prev.vy > 0 and ball_bounds.top < obj_bounds.top then
            self.y = obj_bounds.top - self.r
            self.vy = self.prev.vy * -obj.bounce
        elseif self.prev.vy < 0 and ball_bounds.bottom > obj_bounds.bottom then
            self.y = obj_bounds.bottom + self.r
            self.vy = self.prev.vy * -obj.bounce
        elseif self.vx > 0 and ball_bounds.left < obj_bounds.left then
            self.x = obj_bounds.left - self.r
            self.vx = self.vx * -obj.bounce
        elseif self.vx < 0 and ball_bounds.right > obj_bounds.right then
            self.x = obj_bounds.right + self.r
            self.vx = self.vx * -obj.bounce
        end
        return
    end

    -- Swept collision response using normals
    local t = collision_info.t

    -- Get ball velocity this frame
    local vel_x = self.x - self.prev.x
    local vel_y = self.y - self.prev.y

    -- Get object velocity (if moving)
    local obj_vx = collision_info.b_vx or 0
    local obj_vy = collision_info.b_vy or 0

    -- Move to collision point
    self.x = self.prev.x + vel_x * t
    self.y = self.prev.y + vel_y * t

    -- Apply bounce based on collision normal
    if collision_info.normal_x ~= 0 then
        -- Bounce relative velocity and add object velocity
        local relative_vx = self.vx - obj_vx
        self.vx = relative_vx * -obj.bounce + obj_vx
        vel_x = vel_x * -obj.bounce + obj_vx
    end

    if collision_info.normal_y ~= 0 then
        -- Bounce relative velocity and add object velocity
        local relative_vy = self.vy - obj_vy
        self.vy = relative_vy * -obj.bounce + obj_vy
        vel_y = vel_y * -obj.bounce + obj_vy
    end

    -- Apply remaining motion for (1-t) of the frame
    local remaining = 1 - t
    self.x = self.x + vel_x * remaining
    self.y = self.y + vel_y * remaining

    -- Update bounds after position correction
    self:_update_bounds()
end

function Ball:_calculate_damage()
    -- Damage based on ball speed
    return flr(self:_get_speed()) -- Tuning factor
end

function Ball:_get_speed()
    return sqrt(self.vx^2 + self.vy^2)
end