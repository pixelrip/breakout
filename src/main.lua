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
        x = 28,
        y = 20
    })

    --world:add(arena)
    world:add(p1, "player")
    world:add(p2, "player")
    world:add(ball, "ball")
end

function _update()
    world:update()
end

function _draw()
    cls(2)
    world:draw()
end
