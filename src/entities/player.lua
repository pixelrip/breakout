-- player.lua
-- player entity with paddle control


Player = {}
Player.__index = Player

setmetatable(Player, {__index = Entity})

function Player.new(opts) 
    -- Base entity
    local self = Entity.new({
        x = opts.x or 64,
        y = opts.y or 120,
    })

    setmetatable(self, Player)
        
    -- compose behavior with components
    self:add_component(Paddle.new(self, {
        col = 7,
        bounce = 0.8
    }))

    return self
end