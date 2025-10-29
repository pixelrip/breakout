
-- log to console
-- run `tail -f log.p8l` in terminal
function log(txt)
    printh(txt, "log.p8l")
end


function get_slope(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    
    if dx == 0 then
        return nil
    end
    
    return dy / dx
end

function get_y_intercept(m, x, y)
    if m == nil then
        return nil
    end
    
    -- c = y - (m * x)
    return y - (m * x)
end


function rnd_between(min, max)
    return flr(rnd(max - min + 1) + min)
end

function circle_line_collision(circle, line)
    local line_y_at_circle = (line.m * circle.owner.x) + line.c

    if circle.bottom >= line_y_at_circle and
		circle.top <= line.lowest_y and
		circle.left >= line.x1 and
		circle.right <= line.x2 then
		return line_y_at_circle
	end

    return false
end