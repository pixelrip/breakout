pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- tunneling issue poc
-- by pixelrip

-- tabs:
-- 1: helpers - math functions, etc
-- 2: collision - detection functions
-- 3: ball - circle object
-- 4: edge - single line object
-- 5: box - rectangle object
-- 6: main loops - init, update, draw

-->8
-- helpers
-- useful functions

function get_slope(l)
 -- returns the slope (m)
 -- of a line object
 local dx = l.x2 - l.x1
 local dy = l.y2 - l.y1

	if (dx == 0) return nil
	
 return dy / dx
end

function get_y_intercept(l)
 -- returns the y-int (c)
 -- of a line object
 -- requires slope (m)
 
 if (l.m == nil) return nil
 return l.y1 - (l.m * l.x1)
end


function get_line_y_at_ball(b,l)
	-- returns the y position of
	-- the spot where the ball 
	-- hits the line
	return (l.m * b.x) + l.c
end
-->8
-- collision 
-- detection functions

function ball_vs_edge(b,e)
 local ey = get_line_y_at_ball(b,e)
 
	if b.bottom >= ey and
				b.top <= e.bottom and
				b.left >= e.x1 and
				b.right <= e.x2 then

		return true
	end
	
	return false
end
-->8
-- ball
-- global object

ball = {}

function ball:init()
	self.x = 64
	self.y = 0
		
	self.r = 2 -- radius
	self.col = 7 -- color
	
	-- bounds (update_bounds())
	self.top = 0
	self.bottom = 0
	self.left = 0
	self.right = 0
		
	-- velocity
	self.vx = 0
	self.vy = 0
	self.prev_vx = 0
	self.prev_vy = 0
		
		-- speed
	self.sp = 1
end
	
function ball:update()
	-- store vel from prev frame
	self.prev_vx = self.vx
	self.prev_vy = self.vy

 -- increase speed
	self.vy += self.sp
	
	-- move ball
	self.x += self.vx
	self.y += self.vy
	
	-- update bounds
	self:update_bounds()
end

	
function ball:draw()
	circfill(self.x, self.y, self.r, self.col)
	pset(self.x, self.y, 8)
end


function ball:update_bounds()
	self.top = self.y - self.r
	self.bottom = self.y + self.r
	self.left = self.x - self.r
	self.right = self.x + self.r
end


function ball:on_edge_collision(l)
 local ey = get_line_y_at_ball(self,l) 
 
 -- correct position
 self.y = ey - self.r
 
 -- invert velocity
 self.vy = -self.vy
 
 -- "nudge" it based on slope
 self.vx += l.m * self.prev_vy
 
end
-->8
-- edge (line)
-- global object

edge = {}

function edge:init()
	self.x = 64
	self.y = 104
	self.w = 24
	self.a = 0.05
	self.col = 7
	
	self:update_endpoints()
	self:update_math()
end
	
function edge:update()
	self:update_endpoints()
	self:update_math()
end

function edge:draw()
	line(self.x1, self.y1, self.x2, self.y2, self.col)
	pset(self.x, self.y, 8)
end

--

function edge:update_endpoints()
	local hw = self.w/2
	local dx = cos(self.a) * hw
	local dy = sin(self.a) * hw
	
	self.x1 = self.x-dx
	self.y1 = self.y-dy
	
	self.x2 = self.x+dx
	self.y2 = self.y+dy	
end

function edge:update_math()
	self.bottom = max(self.y1, self.y2)
	self.m = get_slope(self)
	self.c = get_y_intercept(self)
end

function edge:on_ball_collision()
	
end 


-->8
-- box
-- global object

box = {}
-->8
-- main loops
-- _init(), _update(), _draw()

function _init()
	ball:init()
	edge:init()
end

function _update()
	ball:update()
	edge:update()
	
	-- collision checks
	if ball_vs_edge(ball,edge) then
		ball:on_edge_collision(edge)
		edge:on_ball_collision(ball)
	end
end

function _draw()
 cls(0)
	ball:draw()
	edge:draw()
	
	--debug:
	print(edge.x1,2,2,7)
	print(edge.x2,2,8,7)
	print(edge.y1,2,14,7)
	print(edge.y2,2,20,7)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
