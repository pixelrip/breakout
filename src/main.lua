function _init()
    paddle = Paddle.new({
        x = 64,
        y = 120
    })

    world:add(paddle)
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