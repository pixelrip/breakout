-- title screen state

state_title = {
  num_players = 1,
}

function state_title:init()
  self.num_players = 1
end

function state_title:update()
  -- toggle player count with up/down
  if btnp(2) or btnp(3) then  -- up or down
    self.num_players = 3 - self.num_players  -- toggle between 1 and 2
  end

  -- start game with X button
  if btnp(5) then
    state_playing.num_players = self.num_players
    state:set("playing")
  end
end

function state_title:draw()
  -- title
  print("breakout", 44, 40, 7)

  -- player selection
  local c1 = self.num_players == 1 and 11 or 5
  local c2 = self.num_players == 2 and 11 or 5
  print("1 player", 44, 60, c1)
  print("2 player", 44, 68, c2)

  -- instructions
  print("press x to start", 28, 90, 6)
end
