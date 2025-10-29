world = {
    entities = {},
    players = {},
    balls = {}
}

function world:add(e, type)
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

    -- Check for collisions
    self:check_ball_player_collisions()
end

function world:draw()
    for e in all(self.entities) do
        e:draw()
    end
end

function world:check_ball_player_collisions()
    for b in all(self.balls) do
        for p in all(self.players) do
            -- TODO
        end
    end
end