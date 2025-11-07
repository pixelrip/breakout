-- particle.lua
-- Pooled particle system for effects

particles = {
    pool = {},
    max_particles = 250
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

function particles:waterfall(idx, x1, y1, x2, y2)
    -- tuning parameters
    local frequency = 0.9  -- Probability per pixel (0-1)
    local speed = 1
    local life = 2

    local c1, c2 = P1, P5
    if idx == 1 then
        c1, c2 = S1, S5
    end


    -- Calculate line length and direction
    local dx = x2 - x1
    local dy = y2 - y1
    local dist = sqrt(dx * dx + dy * dy)

    -- Iterate through each pixel along the line
    for i = 0, dist do
        -- Check random frequency
        if rnd() < frequency then
            -- Calculate position along line
            local t = i / max(dist, 1)
            local x = x1 + dx * t
            local y = y1 + dy * t

            -- Get inactive particle
            local part = self:get_inactive_particle()
            if part then
                part.active = true
                part.x = x
                part.y = y+1
                part.vx = -0.2 + rnd(0.4)  -- Small horizontal variance
                part.vy = speed * (0.8 + rnd(0.4))  -- Downward with variance
                part.life = life + flr(rnd(5))
                part.max_life = part.life
                part.c1 = c1
                part.c2 = c2
                part.size = 0
                part.gravity = true
                part.friction = 0.98
            end
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
