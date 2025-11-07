DEBUG = true

function _init()
  log("\n\n --------------------")

  -- initialize core systems
  color:init()

  -- register game states
  state:register("title", state_title)
  state:register("playing", state_playing)
  state:register("gameover", state_gameover)

  -- start at title screen
  state:set("title")
end

function _update()
  state:update()
end

function _draw()
  cls(BLACK)
  state:draw()
end
