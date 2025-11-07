-- particle.lua
-- Pooled particle system for effects

particles = {
    pool = {},
    max_particles = 150
}

function particles:init()
    -- Pre-allocate particle pool
    for i = 1, self.max_particles do
        self.pool[i] = {
            active = false,
            x = 0,
            y = 0,
            vx = 0,
            vy = 0,
            life = 0,
            max_life = 0,
            c1 = 0,
            c2 = 0,
            size = 0,
            gravity = false,
            friction = 1.0
        }
    end
end

function particles:update()
    for p in all(self.pool) do
        if p.active then
            -- Update position
            p.x += p.vx
            p.y += p.vy

            -- Apply friction
            p.vx *= p.friction
            p.vy *= p.friction

            -- Apply gravity
            if p.gravity then
                p.vy += 0.1
            end

            -- Update life
            p.life -= 1
            if p.life <= 0 then
                p.active = false
            end
        end
    end
end

function particles:draw()
    for p in all(self.pool) do
        if p.active then
            -- Interpolate color based on remaining life
            local t = p.life / p.max_life
            local c = self:lerp_color(p.c1, p.c2, 1 - t)

            -- Draw particle
            if p.size == 0 then
                pset(p.x, p.y, c)
            else
                circfill(p.x, p.y, p.size, c)
            end
        end
    end
end

function particles:spawn_explosion(x, y, count, c1, c2, opts)
    opts = opts or {}
    local size = opts.size or 0
    local speed = opts.speed or 1.0
    local life = opts.life or 20
    local gravity = opts.gravity or false
    local friction = opts.friction or 0.95

    for i = 1, count do
        local p = self:get_inactive_particle()
        if p then
            -- Random angle for explosion
            local angle = rnd(1)
            local vel = (0.5 + rnd(0.5)) * speed

            p.active = true
            p.x = x
            p.y = y
            p.vx = cos(angle) * vel
            p.vy = sin(angle) * vel
            p.life = life + flr(rnd(10)) -- Add some variance
            p.max_life = p.life
            p.c1 = c1
            p.c2 = c2
            p.size = size
            p.gravity = gravity
            p.friction = friction
        end
    end
end

function particles:get_inactive_particle()
    for p in all(self.pool) do
        if not p.active then
            return p
        end
    end
    return nil
end

function particles:lerp_color(c1, c2, t)
    -- Simple discrete lerp between color indices
    -- Assumes c1 and c2 are in a gradient (e.g., p1 to p5)
    local steps = abs(c2 - c1)
    if steps == 0 then return c1 end

    local step = flr(t * steps)
    if c1 < c2 then
        return c1 + step
    else
        return c1 - step
    end
end
