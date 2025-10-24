function _init()
    paddle = Paddle.new({
        x = 64,
        y = 120
    })

    ball = Ball.new({
        x = 64,
        y = 60,
        dx = 0,
        dy = 0
    })

    world:add(paddle)
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
