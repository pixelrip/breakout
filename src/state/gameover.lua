-- game over state

state_gameover = {
  final_score = 0,
}

function state_gameover:init()
  self.final_score = game.score or 0
end

function state_gameover:update()
  -- return to title on any button press
  if btnp(5) then  -- X button
    state:set("title")
  end
end

function state_gameover:draw()
  -- game over text
  print("game over", 42, 50, 7)

  -- final score
  print("score: " .. self.final_score, 40, 64, 6)

  -- instructions
  print("press x to continue", 24, 90, 5)
end
