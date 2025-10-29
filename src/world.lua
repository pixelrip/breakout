world = {
    entities = {},
    players = {},
    balls = {}
}

function world:add(e, type)
    local type = type or false

    add(self.entities, e)

    -- Add to specific lists
    if type == "player" then
        add(self.players, e)
    elseif type == "ball" then
        add(self.balls, e)
    end
end

function world:update()
    for e in all(self.entities) do
        e:update()
    end
end

function world:draw()
    for e in all(self.entities) do
        e:draw()
    end
end