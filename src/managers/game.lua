-- game.lua
-- manages game state, scoring, and combo system

game = {
  score = 0,
  combo = 1,  -- multiplier (1x, 2x, 3x, etc.)
  last_player_hit = nil,  -- track for alternation
}

function game:reset()
  self.score = 0
  self.combo = 1
  self.last_player_hit = nil
end

function game:update_last_player_hit(player_num)
  -- called when a player hits the ball
  -- check for alternation to build combo
  if self.last_player_hit and self.last_player_hit != player_num then
    -- players alternated! increase combo
    self.combo += 1
  else
    -- same player hit twice, reset combo
    self.combo = 1
  end

  self.last_player_hit = player_num
end

function game:on_brick_destroyed(value)
  -- called when a brick is destroyed
  local points = value * self.combo
  self.score += points
end

-- TODO: Implement ball lost logic
function game:on_ball_lost()
  -- called when ball goes out of bounds
  -- reset combo on failure
  self.combo = 1
  self.last_player_hit = nil
end

function game:draw_hud()
  -- draw score and combo at top of screen
  print("score: "..self.score, 2, 2, 7)
  print("combo: x"..self.combo, 80, 2, 7)

end
