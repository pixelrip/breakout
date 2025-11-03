world = {
    entities = {},
    players = {},
    balls = {},
    walls = {},
    bricks = {},
}

function world:add(e, type)
    local type = type or false

    add(self.entities, e)

    -- Add to specific lists
    if type == "player" then
        add(self.players, e)
    elseif type == "ball" then
        add(self.balls, e)
    elseif type == "wall" then
        add(self.walls, e)
    elseif type == "brick" then
        add(self.bricks, e)
    end
end

function world:remove(e, type)
    del(self.entities, e)

    -- Remove from specific lists
    if type == "player" then
        del(self.players, e)
    elseif type == "ball" then
        del(self.balls, e)
    elseif type == "wall" then
        del(self.walls, e)
    elseif type == "brick" then
        del(self.bricks, e)
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