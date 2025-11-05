color = {}

color.c = {
    black = 0,
    white = 1,
    grey = 2,
    dark_grey = 3,
    p1 = 4, -- primary
    p2 = 5,
    p3 = 6,
    p4 = 7,
    p5 = 8,
    s1 = 9, -- secondary
    s2 = 10,
    s3 = 11,
    s4 = 12,
    s5 = 13,
    acc1 = 14,
    acc2 = 15    
}

color.sets = {
    -- primary: lime, secondary: red, accent: blue + orange
    base = "0,7,6,5,",
    
    -- 5 color sets
    lime = "-9,10,-6,-5,3,",
    rose = "14,8,-8,2,-14,",
    sand = "15,-1,4,-12,-16,",
    night = "6,13,-3,2,-14,",
    clover = "11,-5,3,-13,-15,",
    smurf = "6,12,-4,1,-15,",
    oro = "-9,9,4,-12,-16,",
    salmon = "15,-1,-2,4,-12,",

    -- accent color sets
    blue_orange = "12,9",
    red_blue = "8,12",
}

color.current = {}

function color:init()
    poke(0x5f2e,1)
    self:set_palette(1)
end

function color:set_palette(level)
    local p = self:make_palette(level)
    pal(self.current,1)
end

function color:make_palette(level)
    local level = level or 0
    local s = self.sets
    local p = s.base
    local custom_palette = {}

    -- TODO: experiment with combined palettes
    if level == 0 then
        p = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
    elseif level == 1 then
        p = p .. s.salmon .. s.night .. s.blue_orange
    else
        p = p .. s.smurf .. s.rose .. s.blue_orange
    end
    
    p = split(p, ",")

    for i = 0, 15 do
        custom_palette[i] = p[i+1]
    end

    self.current = custom_palette
    return self.current
end


function color:reset_palette()
    pal()
    pal(self.current,1)
end

-- token helper
function get_color(n)
    return color.c[n]
end
