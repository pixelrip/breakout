-- Rotation component
-- Allows an entity to be rotated

Rotation = {}
Rotation.__index = Rotation

function Rotation.new(owner, opts)
    local self = setmetatable({}, Rotation)

    self.angle = opts.angle or 0
    -- TODO: Rotation properties

    return self
end

-- TODO: Rotation methods: rotate, etc
