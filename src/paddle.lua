paddle = {
    x = 64,
    y = 120,
    w = 28,
    h = 4, 
    a = 0, -- current angle
    col = 7, -- color

    -- state for tracking input
    -- 0 = neutral
    -- -1 = tilting left
    -- 1 = tilting right
    tilt_dir = 0,

    -- tuning variables
    MAX_A = 0.08, -- max angle
    ROT_SPEED = 0.01, -- 0.01
    SNAP_SPEED = 0.04,
 
    -- "Public" Methods
    update = function(self)
        local left = btn(4)
        local right = btn(5)

        -- 1. Check for new button presses
        if left and self.tilt_dir == 0 then
            self.tilt_dir = -1 -- start tilting left
        elseif right and self.tilt_dir == 0 then
            self.tilt_dir = 1 -- start tilting right
        end

        -- 2. Update angle based on tilt direction
        if self.tilt_dir == -1 then
            -- We are in "tilting left" mode
            if not left then
            self.tilt_dir = 0 -- Player released left, go to neutral
            else
            -- Player is holding left, increase tilt
            self.a = max(-self.MAX_A, self.a - self.ROT_SPEED)
            end
            
        elseif self.tilt_dir == 1 then
            -- We are in "tilting right" mode
            if not right then
            self.tilt_dir = 0 -- Player released right, go to neutral
            else
            -- Player is holding right, increase tilt
            self.a = min(self.MAX_A, self.a + self.ROT_SPEED)
            end
        end

        -- 3. Handle snap-back when in neutral
        if self.tilt_dir == 0 and self.a != 0 then
            if self.a > 0 then
            -- it's tilted right, snap left
            self.a = max(0, self.a - self.SNAP_SPEED)
            elseif self.a < 0 then
            -- it's tilted left, snap right
            self.a = min(0, self.a + self.SNAP_SPEED)
            end
        end
    end,

    draw = function(self)
        local hw = self.w / 2 -- half-width
        local hh = self.h / 2 -- half-height
        
        -- pre-calculate sin/cos
        -- self.a is in PICO-8's 0-1 format
        local c = cos(self.a)
        local s = sin(self.a)

        -- calculate the 4 corner vectors
        local v1x, v1y = hw*c, hw*s
        local v2x, v2y = -hh*s, hh*c

        -- calculate the 4 absolute corner positions
        local x1 = self.x - v1x + v2x
        local y1 = self.y - v1y + v2y
        local x2 = self.x + v1x + v2x
        local y2 = self.y + v1y + v2y
        local x3 = self.x + v1x - v2x
        local y3 = self.y + v1y - v2y
        local x4 = self.x - v1x - v2x
        local y4 = self.y - v1y - v2y

        -- draw the 4 lines connecting the corners
        -- this draws a hollow rect, which is
        -- perfect for a proof-of-concept.
        line(x1, y1, x2, y2, self.col)
        line(x2, y2, x3, y3, self.col)
        line(x3, y3, x4, y4, self.col)
        line(x4, y4, x1, y1, self.col)
    end,


}