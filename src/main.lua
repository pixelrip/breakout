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

    p1 = Player.new({
        x = 28,
        y = 120,
        idx = 0
    })

    p2 = Player.new({
        x = 93,
        y = 120,
        idx = 1
    })

    ball = Ball.new({
        x = 64,
        y = 20
    })

    --world:add(arena)
    world:add(p1)
    world:add(p2)
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
