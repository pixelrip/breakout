pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- tunneling issue: continuous collision detection solution
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


function log(txt)
	printh(txt, "ccd.p8l")
end
-->8
-- collision 
-- detection functions

function ball_vs_edge(b,e)
	local pr = b.pr
	local p_ey = get_line_y_at_ball(pr,e)
	local c_ey = get_line_y_at_ball(b,e)


	if pr.bottom <= p_ey and b.bottom >= c_ey then
		-- find intersection point with lerp
		local t = (c_ey - pr.bottom) / (b.bottom - pr.bottom)
	
		-- get exact collision point
		local hit_x = pr.x + (b.x - pr.x) * t
		local hit_y = pr.y + (b.y - pr.y) * t

  		-- was collision point within line bounds?
		if hit_x >= e.x1 and
			hit_x <= e.x2 then

			--debug
			b.snapshots = {{x=pr.x,y=pr.y,col=1},{x=b.x,y=b.y,col=1},{x=hit_x,y=hit_y,col=2}}
			log("ball_vs_edge():")
			log("  p_ey:      "..p_ey)
			log("  c_ey:      "..c_ey)
			log("  pr. (previous frame data for ball)")
			log("     x:      "..pr.x)
			log("     y:      "..pr.y)
			log("     vx:     "..pr.vx)
			log("     vy:     "..pr.vy)
			log("     top:    "..pr.top)
			log("     bottom: "..pr.bottom)
			log("     left:   "..pr.left)
			log("     right:  "..pr.right)
			log("  b. (current frame data for ball)")
			log("     x:      "..b.x)
			log("     y:      "..b.y)
			log("     vx:     "..b.vx)
			log("     vy:     "..b.vy)
			log("     top:    "..b.top)
			log("     bottom: "..b.bottom)
			log("     left:   "..b.left)
			log("     right:  "..b.right)
			log("  e. (current frame data for edge)")
			log("     x1:     "..e.x1)
			log("     y1:     "..e.y1)
			log("     x2:     "..e.x2)
			log("     y2:     "..e.y2)
			log("     m:      "..e.m)
			log("     c:      "..e.c)
			log("  t:         "..t)
			log("  hit_x:     "..hit_x)
			log("  hit_y:     "..hit_y)
			
		return true, hit_x, hit_y
  		end
	end

	-- simple check for when ball is very close to edge
	-- (to avoid tunneling when moving slowly)
	local buffer = 1
    if b.bottom > c_ey and b.bottom < c_ey + buffer then
        if b.x >= e.x1 and b.x <= e.x2 then
            return true, b.x, c_ey - b.r
        end
    end
	
	return false
end
-->8
-- ball
-- global object

ball = {}

function ball:init()
 -- position
	self.x = 64
	self.y = 0
		
	-- radius
	self.r = 2
	
	-- bounds (update_bounds())
	self.top = 0
	self.bottom = 0
	self.left = 0
	self.right = 0
		
	-- velocity
	self.vx = 0
	self.vy = 0
		
	-- speed
	self.sp = 0.2
	
	-- previous frame data
	self.pr = {}
	-- history snapshots
	self.snapshots = {}
end
	
function ball:update()
	-- data from prev frame
	self:store_prev_frame_data()

 -- increase speed
	self.vy += self.sp
	
	-- move ball
	self.x += self.vx
	self.y += self.vy
	
	-- update bounds
	self:update_bounds()
end

	
function ball:draw()
	circfill(self.x, self.y, self.r, 12)
	pset(self.x, self.y, 7)
	
	-- draw snapshots
	for s in all(self.snapshots) do
		circfill(s.x, s.y, self.r, s.col)
	end

	-- draw a line between snapshots
	if #self.snapshots >= 2 then
		line(self.snapshots[1].x, self.snapshots[1].y,
			 self.snapshots[2].x, self.snapshots[2].y, 11)
	end

	--debug
	print("x: "..self.x,100,14,12)
	print("y: "..self.y,100,20,12)
end

function ball:reset()
	self.x = 64
	self.y = 0
	self.vx = 0
	self.vy = 0
end


function ball:update_bounds()
	self.top = self.y - self.r
	self.bottom = self.y + self.r
	self.left = self.x - self.r
	self.right = self.x + self.r
end


function ball:store_prev_frame_data()
	local pr = self.pr
	pr.x = self.x
	pr.y = self.y
	pr.vx = self.vx
	pr.vy = self.vy
	pr.top = self.top
	pr.bottom = self.bottom
	pr.left = self.left
	pr.right = self.right
end


function ball:on_edge_collision(l,hit)
 
 -- correct position
 self.x = hit[1]
 self.y = hit[2]
 
 -- invert velocity
 self.vy = -self.pr.vy * l.bounce * 1 --tuning
 
 -- "nudge" it based on slope
 self.vx += l.m * self.pr.vy
 
end
-->8
-- edge (line)
-- global object

edge = {}

function edge:init()
	self.x = 64
	self.y = 104
	self.w = 128
	self.a = 0.0
	self.bounce = 0.8
	
	self:update_endpoints()
	self:update_math()
end
	
function edge:update()
	self:update_endpoints()
	self:update_math()
end

function edge:draw()
	line(self.x1, self.y1, self.x2, self.y2, 8)
	pset(self.x, self.y, 7)
	
	--debug:
	print("x: "..self.x,100,2,8)
	print("y: "..self.y,100,8,8)
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
	-- debug
 	log("\n\n------")

	-- init objects
	ball:init()
	edge:init()
end

function _update()
	ball:update()
	edge:update()
	
	-- collision checks
	local hit, hit_x, hit_y = ball_vs_edge(ball,edge) 
	if hit then
		ball:on_edge_collision(edge, {hit_x, hit_y})
		--edge:on_ball_collision(ball)
	end

	-- simple reset if ball goes off screen
	if ball.y > 200 then
		ball:reset()
	end
end

function _draw()
	cls(0)
	ball:draw()
	edge:draw()


end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
