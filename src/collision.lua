-- Collision Detection Functions

function circle_vs_line(c, l)
    local prev_c = c.prev
    local prev_l = l.prev

    -- Use previous frame's line position for previous y calculation
    local p_ly = get_line_y_at_ball(prev_c, prev_l)
    local c_ly = get_line_y_at_ball(c, l)

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

    -- TODO: Avoid tunneling when moving slowly (e.g., buffer zone)


    return false
end