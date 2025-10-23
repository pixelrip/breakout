
-- log to console
-- run `tail -f log.p8l` in terminal
function log(txt)
    printh(txt, "log.p8l")
end

-- draw rectagles of any angle
-- obj expects {x,y,w,h,a,col}
function draw_rect(obj)
    local hw = obj.w / 2 -- half-width
    local hh = obj.h / 2 -- half-height
    
    -- pre-calculate sin/cos
    -- obj.a is in PICO-8's 0-1 format
    local c = cos(obj.a)
    local s = sin(obj.a)

    -- calculate the 4 corner vectors
    local v1x, v1y = hw*c, hw*s
    local v2x, v2y = -hh*s, hh*c

    -- calculate the 4 absolute corner positions
    local x1 = obj.x - v1x + v2x
    local y1 = obj.y - v1y + v2y
    local x2 = obj.x + v1x + v2x
    local y2 = obj.y + v1y + v2y
    local x3 = obj.x + v1x - v2x
    local y3 = obj.y + v1y - v2y
    local x4 = obj.x - v1x - v2x
    local y4 = obj.y - v1y - v2y

    -- draw the 4 lines connecting the corners
    -- this draws a hollow rect, which is
    -- perfect for a proof-of-concept.
    line(x1, y1, x2, y2, obj.col)
    line(x2, y2, x3, y3, obj.col)
    line(x3, y3, x4, y4, obj.col)
    line(x4, y4, x1, y1, obj.col)
end