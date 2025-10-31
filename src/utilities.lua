
-- log to console
-- run `tail -f log.p8l` in terminal
function log(txt)
    printh(txt, "log.p8l")
end


function get_slope(l)
    local dx = l.x2 - l.x1
    local dy = l.y2 - l.y1

    if dx == 0 then return nil end
    
    return dy / dx
end

function get_y_intercept(l)
    if l.m == nil then return nil end
    
    -- c = y - (m * x)
    return l.y1 - (l.m * l.x1)
end

function get_line_y_at_ball(b,l)
	-- returns the y position of
	-- the spot where the ball 
	-- hits the line
	return (l.m * b.x) + l.c
end

function rnd_between(min, max)
    return flr(rnd(max - min + 1) + min)
end