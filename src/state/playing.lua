-- playing state

state_playing = {
  num_players = 1,
}

function state_playing:init()
  -- clear world
  world.players = {}
  world.balls = {}
  world.walls = {}
  world.bricks = {}

  -- add arena walls
  world:add(Wall.new({
    x = 0,
    y = 0,
    width = 2,
    height = 128,
  }), "wall")

  world:add(Wall.new({
    x = 126,
    y = 0,
    width = 2,
    height = 128,
  }), "wall")

  world:add(Wall.new({
    x = 0,
    y = 0,
    width = 128,
    height = 2,
  }), "wall")

  -- add moving wall
  world:add(Wall.new({
    x = 0,
    y = 60,
    width = 28,
    height = 2,
    vx = 0.5
  }), "wall")

  -- add player(s)
  if self.num_players == 1 then
    local p1 = Player.new({
      x = 64,
      y = 120,
      idx = 0
    })
    world:add(p1, "player")
  else
    local p1 = Player.new({
      x = 28,
      y = 120,
      idx = 0
    })
    local p2 = Player.new({
      x = 93,
      y = 120,
      idx = 1
    })
    world:add(p1, "player")
    world:add(p2, "player")
  end

  -- add ball
  local ball = Ball.new({
    x = 64,
    y = 64
  })
  world:add(ball, "ball")

  -- add bricks
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

  -- initialize input and game
  input:init()
  game:reset()
end

function state_playing:update()
  input:update()
  world:update()

  -- TODO: check for game over condition
  -- if game.lives <= 0 then
  --   state:set("gameover")
  -- end
end

function state_playing:draw()
  world:draw()
  game:draw_hud()
end
