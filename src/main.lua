DEBUG = true

function _init()
    --[[
    arena = Arena.new({
        x = 0,
        y = 0,
        width = 128,
        height = 128,
        wall_thickness = 2,
        color = 10
    })
    ]]--

    player = Player.new({
        x = 64,
        y = 120
    })

    ball = Ball.new({
        x = 64,
        y = 60,
        vx = 0,
        vy = 0
    })

    --world:add(arena)
    world:add(player)
    world:add(ball)
end

function _update()
    for e in all(world.entities) do
        e:update()
    end
end

function _draw()
    cls(2)
    
    for e in all(world.entities) do
        e:draw()
    end

end
