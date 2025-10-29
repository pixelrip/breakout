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
    
    -- Player properties (Player 1=0, Player 2=1)
    self.idx = opts.idx or 0

    -- compose behavior with components
    self:add_component(Mover.new(self, {
        max_speed = 2,
        friction = 0.2
    }))
    self:add_component(Paddle.new(self, {
        col = 7,
        bounce = 0.8
    }))
    self:add_component(PaddleInput.new(self, {
        acceleration = 0.5
    }))

    return self
end