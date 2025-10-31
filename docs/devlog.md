# Dev Log
Total Time: 23hrs

## TODO:

## Possible optimizations:
- [Shrinko8](https://github.com/thisismypassport/shrinko8)
- rectangle.lua could draw simpler rectangles if there is no angle (token / performance tradeoff)
- Lot of duplication with the tuning constants and entity creation

---

## Daily Notes

### Day 5: 2025-10-31
- Time Worked: 5hrs
- Continuing work on collision POC
- POC works super well with any ball velocity (great!) but I'm inevitably going to run into problems with my moving paddles (shit!). Going to push ahead on the main game at this point though. 
- Hit a wall with my own math understanding but leaned on claude to get things to a working point. Not happy about that but in the name of progress it had to be done.
- Paddle and ball working well and the speed it pretty incredible and the wall / platform ideas are pretty extensible.
- I may have used half my time, but the "pinball feel" I've been going for is pretty spot on, so I'm happy. 
- Next week: Bricks!


### Day 4: 2025-10-30
- Time Worked: 4hrs
- Todays question: Fix borderline unshippable collision bugs or add the bricks? I may regret the choice, but given I'm likely only going to introduce more collisions (bottom of paddle, bricks, pickups) I'm going to devote today to a collision poc.
- Began putting together proof-of-concept for "continuous collision detection" in poc/ccd.p8
- WIP on POC; CCD almost working; still want tit to bounce off bt bottom/sides of the paddle as well.


### Day 3: 2025-10-29
- Time Worked: 6hrs
- Refactor player/paddle
- Refactor entity tracking in world
- Refactor ball/paddle collisions
- Paddle/ball physics starting to feel pretty solid; definitely still some collision/tunneling issues though

### Day 2: 2025-10-27
- Time Worked: 4hrs
- Took a step back and got a better understanding of the actual physics I need. Put together a proof of concept here: https://github.com/pixelrip/ball-platform-physics
- WIP: Refactoring this code entirely


### Day 1: 2025-10-24

- Time worked: 4hrs
- Proof of concept for rotating paddle
- Futzing with hybrid component-based architecture, probably overkill and I run the risk of token limitats--but good for learning
- Created Mover and InputMover component, integrated with paddle
- Created Ball entity and added some pinball style physics
- Created Arena entity which is basically just visual right now (but adjustable)

