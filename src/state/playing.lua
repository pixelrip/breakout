-- playing state
state_playing = {}

function state_playing:init(players)
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
  --[[
  world:add(Wall.new({
    x = 0,
    y = 60,
    width = 28,
    height = 2,
    vx = 0.5
  }), "wall")
]]--

  if players[1] then
    world:add(Player.new({
      x = 28,
      y = 120,
      idx = 0
    }), "player")
  end

  if players[2] then
    world:add(Player.new({
      x = 93,
      y = 120,
      idx = 1
    }), "player")
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

  -- initialize input, game, and particles
  input:init()
  game:reset()
  particles:init()
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
