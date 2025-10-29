input = {
    current = {},
    previous = {},
}

-- "Public" methods
function input:init()
    for p in all(world.players) do
        local n = p.idx + 1
        self.current[n] = {}
        self.previous[n] = {}

        for b = 0, 5 do
            self.current[n][b] = false
            self.previous[n][b] = false
        end
    end
end

function input:update()
    for p in all(world.players) do
        local n = p.idx + 1

        for b = 0, 5 do
            -- Store previous state
            self.previous[n][b] = self.current[n][b]
            self.current[n][b] = btn(b, p.idx)
        end
    end
end

function input:onpress(b, player)
    local n = player.idx + 1
    return not self.previous[n][b] and self.current[n][b]
end

function input:onhold(b, player)
    local n = player.idx + 1
    return self.current[n][b]
end

function input:onrelease(b, player)
    local n = player.idx + 1
    return self.previous[n][b] and not self.current[n][b]
end