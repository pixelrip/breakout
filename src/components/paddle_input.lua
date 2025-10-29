-- PaddleInput Component
-- Reads player input and translates it into velocity changes

PaddleInput = {}
PaddleInput.__index = PaddleInput

PaddleInput.MAX_OFFSET = 6

function PaddleInput.new(owner, opts)
    local self = setmetatable({}, PaddleInput)
    self.owner = owner
    
    -- Properties
    self.acceleration = opts.acceleration or 0.5

    return self
end

function PaddleInput:update()
    -- Required components
    local mover = self.owner:get_component(Mover)
    local paddle = self.owner:get_component(Paddle)

    local idx = self.owner.idx
    local up = btn(2, idx)
    local down = btn(3, idx)
    local left = btn(0, idx)
    local right = btn(1, idx)

    -- Apply acceleration based on input
    if left then mover.vx -= self.acceleration end
    if right then mover.vx += self.acceleration end
    if up then mover.vy -= self.acceleration end
    if down then mover.vy += self.acceleration end

    -- Turning the platform
    local o = btn(4, idx)
    local x = btn(5, idx)

    if o and not x then
        paddle.tilt_y1 = 6
        paddle.tilt_y2 = -6
    elseif x and not o then
        paddle.tilt_y1 = -6
        paddle.tilt_y2 = 6
    else
        paddle.tilt_y1 = 0
        paddle.tilt_y2 = 0  
   end



end
