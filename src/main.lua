function _init()
    paddle = Paddle.new(64,120)
end

function _update()
    paddle:update()
end

function _draw()
    cls(2)
    print('breakout', 2, 2, 7)

    paddle:draw()
end