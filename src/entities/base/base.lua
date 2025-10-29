-- Base Entity Class
Entity = {}
Entity.__index = Entity

function Entity.new(opts)
    local opts = opts or {}
    local self = setmetatable({}, Entity)
    
    -- Core Properties
    -- Some invisible entities don't actually need them.    
    self.x = opts.x or 0
    self.y = opts.y or 0

    -- Component host fields
    self._updateables = {}
    self._drawables = {}

    return self
end

function Entity:update()
    for c in all(self._updateables) do c:update() end
end

function Entity:draw()
    for c in all(self._drawables) do c:draw() end
end
