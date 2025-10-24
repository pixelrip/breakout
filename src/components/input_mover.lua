-- InputMover Component
-- Reads player input and translates it into velocity changes

InputMover = {}
InputMover.__index = InputMover

function InputMover.new(owner, opts)
    local self = setmetatable({}, InputMover)
    self.owner = owner
    
    -- Properties
    self.acceleration = opts.acceleration or 0.5

    return self
end

function InputMover:update()
    -- Required components
    local mover = self.owner:get_component(Mover)

    -- Inputs 
    local left = btn(0)
    local right = btn(1)

    -- Apply acceleration based on input
    if left then
        mover.dx -= self.acceleration
    end
    
    if right then
        mover.dx += self.acceleration
    end
end
