-- state manager
-- handles state transitions and dispatching

state = {
  current = nil,
  states = {},
}

function state:register(name, state_obj)
  self.states[name] = state_obj
end

function state:set(name)
  if self.current then
    local old = self.states[self.current]
    if old.exit then old:exit() end
  end

  self.current = name
  local new = self.states[name]
  if new.init then new:init() end
end

function state:update()
  local s = self.states[self.current]
  if s and s.update then s:update() end
end

function state:draw()
  local s = self.states[self.current]
  if s and s.draw then s:draw() end
end
