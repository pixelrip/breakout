-- title screen state

state_title = {
  num_players = 0,
  p1_joined = false,
  p2_joined = false
}

function state_title:init()
  self.p1_joined = false
  self.p2_joined = false
end

function state_title:update()
  if btn(4,0) and not self.p1_joined then
    self.p1_joined = true
    self.num_players += 1
  end

  if btn(4,1) and not self.p2_joined then
    self.p2_joined = true
    self.num_players += 1
  end

  if self.num_players > 0 and (btn(5,0) or btn(5,1)) then
    state:set("playing", {self.p1_joined, self.p2_joined})
  end
end

function state_title:draw()
  -- TODO: use centering functions
  -- title
  print("breakout", 44, 40, 7)

  -- player 1
  print("player 1", 16, 60, P1)
  if self.p1_joined then
    print("joined", 20, 68, P1)
  else
    print(chr(142).." join", 18, 68, P2)
  end
  
  -- player 2
  print("player 2", 79, 60, S2)
  if self.p2_joined then
    print("joined", 83, 68, S1)
  else
    print(chr(142).." join", 81, 68, S2)
  end

  -- start game
  if self.num_players > 0 then
    print("press "..chr(151).." to start", 30, 100, WHITE) -- text is 67 pixels wide
  end
end
