DEBUG = true

function _init()
    log("\n\n --------------------")
        
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
    

    world:add(Wall.new({
      x = 0,
      y = 60,
      width = 28,
      height = 2,
      color = 12,
      vx = 0.5  -- Moves right at 0.5 pixels/frame
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
        y = 64
    })


    world:add(p1, "player")
    world:add(p2, "player")
    world:add(ball, "ball")


    
    for i = 4,114,10 do
        for j = 14,39,5 do
            world:add(Brick.new({
                x = i,
                y = j,
                width = 10,
                height = 5,
            }), "brick")
        end
    end
    

    input:init()
    game:reset()

end

function _update()

    input:update()
    world:update()
end

function _draw()
    cls(1)
    world:draw()
    game:draw_hud()
end
