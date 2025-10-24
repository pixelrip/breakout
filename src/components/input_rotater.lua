-- InputRotater Component
-- Reads player input and translates it into rotation position

InputRotater = {}
InputRotater.__index = InputRotater

function InputRotater.new(owner, opts)
    local self = setmetatable({}, InputRotater)
    self.owner = owner
    
    -- Properties
    -- input state: 0 = neutral, -1 left, 1 right
    self.tilt_dir = 0
    self.max_angle = opts.max_angle or 1
    self.rotation_speed = opts.rotation_speed or 0.01
    self.snap_speed = opts.snap_speed or 0.04

    return self
end

function InputRotater:update()
    -- Required components
    local rotation = self.owner:get_component(Rotation)

    -- Inputs 
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
        rotation.angle = max(-self.max_angle, rotation.angle - self.rotation_speed)
        end
        
    elseif self.tilt_dir == 1 then
        -- We are in "tilting right" mode
        if not right then
        self.tilt_dir = 0 -- Player released right, go to neutral
        else
        -- Player is holding right, increase tilt
        rotation.angle = min(self.max_angle, rotation.angle + self.rotation_speed)
        end
    end

    -- 3. Handle snap-back when in neutral
    if self.tilt_dir == 0 and rotation.angle != 0 then
        if rotation.angle > 0 then
        -- it's tilted right, snap left
        rotation.angle = max(0, rotation.angle - self.snap_speed)
        elseif rotation.angle < 0 then
        -- it's tilted left, snap right
        rotation.angle = min(0, rotation.angle + self.snap_speed)
        end
    end
end