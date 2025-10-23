-- paddle.lua
-- paddle control
Paddle = {}
Paddle.__index = Paddle

-- Tuning Constants
Paddle.MAX_A = 0.08 -- max angle
Paddle.ROT_SPEED = 0.01 -- 0.01
Paddle.SNAP_SPEED = 0.04

function Paddle.new(_x, _y) 
    local p = {
        x = _x,
        y = _y,
        w = 28,
        h = 4, 
        a = 0, -- current angle
        col = 7, -- color
        
        -- input state: 0 = neutral, -1 left, 1 right
        tilt_dir = 0,
    }
    
    setmetatable(p, Paddle)
    return p
end

function Paddle:update()
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
end

function Paddle:draw()
    draw_rect(self)
end