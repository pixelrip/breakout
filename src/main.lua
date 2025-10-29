DEBUG = true

function _init()
    world:add(Wall.new({
        x = 0,
        y = 0,
        width = 2,
        height = 128,
        color = 10
    }), "wall")

    world:add(Wall.new({
        x = 126,
        y = 0,
        width = 2,
        height = 128,
        color = 10
    }), "wall")

    world:add(Wall.new({
        x = 0,
        y = 0,
        width = 128,
        height = 2,
        color = 10
    }), "wall")
    
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

    world:add(p1, "player")
    world:add(p2, "player")
    world:add(ball, "ball")

    -- Input manager
    input:init()
end

function _update()
    input:update()
    world:update()
end

function _draw()
    cls(2)
    world:draw()
end
