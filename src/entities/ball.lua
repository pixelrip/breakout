-- ball.lua
-- ball with pinball physics
Ball = {}
Ball.__index = Ball

setmetatable(Ball, {__index = Entity})

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
    local paddle, hit_pos = self:_check_paddle_collisions()
    if paddle then
        self:_on_player_collision(paddle, hit_pos)
    end

    -- Check wall and brick collisions (find earliest)
    local obj, collision_info, obj_type = self:_check_box_collisions()
    if obj then
        if obj_type == "brick" then
            self:_on_brick_collision(obj, collision_info)
        else
            self:_on_wall_collision(obj, collision_info)
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

function Ball:_check_paddle_collisions()
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

function Ball:_on_wall_collision(w, collision_info)
    self:_apply_box_collision(w, collision_info)
end

function Ball:_on_brick_collision(b, collision_info)
    -- Apply collision physics (same as wall)
    self:_apply_box_collision(b, collision_info)

    -- Apply damage (1 damage per hit)
    b.hp -= 1

    -- Destroy brick if hp depleted
    if b.hp <= 0 then
        world:remove(b, "brick")
    end
end