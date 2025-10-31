-- Collision Detection Functions

function circle_vs_line(c, l)
    local prev_c = c.prev
    local prev_l = l.prev

    -- Use previous frame's line position for previous y calculation
    local p_ly = get_line_y_at_ball(prev_c, prev_l)
    local c_ly = get_line_y_at_ball(c, l)

    -- Check for standard crossing collision
    if prev_c.bounds.bottom <= p_ly and c.bounds.bottom >= c_ly then

        -- find intersection point with lerp
        local t = (c_ly - prev_c.bounds.bottom) / (c.bounds.bottom - prev_c.bounds.bottom)

        -- get exact collision point
        local hit_x = prev_c.x + (c.x - prev_c.x) * t
        local hit_y = prev_c.y + (c.y - prev_c.y) * t

        -- interpolate line endpoints at collision time t
        local line_x1_at_t = prev_l.x1 + (l.x1 - prev_l.x1) * t
        local line_x2_at_t = prev_l.x2 + (l.x2 - prev_l.x2) * t

        -- was collision point within interpolated line bounds?
        if hit_x >= line_x1_at_t and hit_x <= line_x2_at_t then
            return true, {x = hit_x, y = hit_y, t = t}
        end
    end

    --[[
    -- I'm not using this for now, because the player should not be
    -- able to hold the ball on the paddle indefinitely

    -- Buffer zone check for slow-moving or resting balls
    -- Check if ball is very close to the paddle surface
    local buffer = 0.5  -- Small buffer distance
    local dist_to_line = abs(c.bounds.bottom - c_ly)

    if dist_to_line <= buffer and c.vy >= -0.1 then  -- Ball is close and not moving up fast
        -- Check if ball center is within paddle bounds
        if c.x >= l.x1 and c.x <= l.x2 then
            -- Ball is resting or very close to paddle
            return true, {x = c.x, y = c_ly - c.r, t = 1}
        end
    end
    ]]--

    return false
end

-- Swept AABB collision detection
-- a = moving object (must have prev.bounds)
-- b = static or moving object
-- Returns: hit (boolean), collision info {normal_x, normal_y, t}
function box_vs_box(a, b)
    -- If no previous frame data, fall back to static check
    if not a.prev or not a.prev.bounds then
        local ab = a.bounds
        local bb = b.bounds
        return not (ab.right < bb.left or
                    ab.left > bb.right or
                    ab.bottom < bb.top or
                    ab.top > bb.bottom)
    end

    local prev_ab = a.prev.bounds
    local curr_ab = a.bounds
    local bb = b.bounds

    -- Calculate velocity (change in position)
    local dx = (curr_ab.left - prev_ab.left)
    local dy = (curr_ab.top - prev_ab.top)

    -- Early exit if no movement
    if dx == 0 and dy == 0 then
        -- Static overlap check
        return not (curr_ab.right < bb.left or
                    curr_ab.left > bb.right or
                    curr_ab.bottom < bb.top or
                    curr_ab.top > bb.bottom)
    end

    -- Calculate time of collision for each axis
    local entry_x, exit_x, entry_y, exit_y

    -- X-axis
    if dx > 0 then
        entry_x = (bb.left - prev_ab.right) / dx
        exit_x = (bb.right - prev_ab.left) / dx
    elseif dx < 0 then
        entry_x = (bb.right - prev_ab.left) / dx
        exit_x = (bb.left - prev_ab.right) / dx
    else
        -- No horizontal movement
        if prev_ab.right < bb.left or prev_ab.left > bb.right then
            return false  -- No overlap on x-axis
        end
        entry_x = -999999
        exit_x = 999999
    end

    -- Y-axis
    if dy > 0 then
        entry_y = (bb.top - prev_ab.bottom) / dy
        exit_y = (bb.bottom - prev_ab.top) / dy
    elseif dy < 0 then
        entry_y = (bb.bottom - prev_ab.top) / dy
        exit_y = (bb.top - prev_ab.bottom) / dy
    else
        -- No vertical movement
        if prev_ab.bottom < bb.top or prev_ab.top > bb.bottom then
            return false  -- No overlap on y-axis
        end
        entry_y = -999999
        exit_y = 999999
    end

    -- Find the earliest and latest times of collision
    local entry_time = max(entry_x, entry_y)
    local exit_time = min(exit_x, exit_y)

    -- No collision if:
    -- - entry time is after exit time
    -- - both collision times are negative (collision in the past)
    -- - entry time is after 1.0 (collision beyond this frame)
    if entry_time > exit_time or exit_time < 0 or entry_time > 1 then
        return false
    end

    -- Collision detected! Calculate normal
    local normal_x = 0
    local normal_y = 0

    -- Use a small epsilon for corner collision detection
    local epsilon = 0.001

    if abs(entry_x - entry_y) < epsilon then
        -- Corner collision - bounce both axes
        normal_x = dx > 0 and -1 or 1
        normal_y = dy > 0 and -1 or 1
    elseif entry_x > entry_y then
        -- Collision on X-axis
        normal_x = dx > 0 and -1 or 1
    else
        -- Collision on Y-axis
        normal_y = dy > 0 and -1 or 1
    end

    return true, {
        normal_x = normal_x,
        normal_y = normal_y,
        t = max(0, entry_time)  -- Clamp to [0, 1]
    }
end