DEBUG = true

function _init()
    arena = Arena.new({
        x = 0,
        y = 0,
        width = 128,
        height = 128,
        wall_thickness = 2,
        color = 10
    })

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

    world:add(arena)
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
    
    -- DEBUG
    if DEBUG then
        local _paddle_rotation = paddle:get_component(Rotation)

        print("paddle x:  "..paddle.x, 3, 3, 7)
        print("paddle y:  "..paddle.y, 3, 9, 7)
        print("paddle x:  "..paddle.w, 3, 15, 7)
        print("paddle y:  "..paddle.h, 3, 21, 7)
        print("paddle a:  ".._paddle_rotation.angle, 3, 27, 7)
    end

    for e in all(world.entities) do
        e:draw()
    end

end
