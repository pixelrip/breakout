function _init()
end

function _update()
    paddle:update()
end

function _draw()
    cls(2)
    print('breakout', 2, 2, 7)

    paddle:draw()
end