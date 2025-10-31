-- Collision Detection Functions

function circle_vs_line(c, l)
    local prev_c = c.prev
    local prev_l = l.prev

    -- Use previous frame's line position for previous y calculation
    local p_ly = get_line_y_at_ball(prev_c, prev_l)
    local c_ly = get_line_y_at_ball(c, l)

    -- Check for standard crossing collision
    if prev_c.bottom <= p_ly and c.bottom >= c_ly then

        -- find intersection point with lerp
        local t = (c_ly - prev_c.bottom) / (c.bottom - prev_c.bottom)

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
    local dist_to_line = abs(c.bottom - c_ly)

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