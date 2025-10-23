# 20 Games Challege Game #02: Breakout

A simple Breakout clone.

## The 20 Games Challenge

In Sept 2025 I found myself deep into learning about game development without actually shipping or sharing many games. Enter the [20 Games Challenge](https://20_games_challenge.gitlab.io). To tackle this audacious and overwhelming challenge I set a few constraints:

1. Complete each game (or working vertical slice of a game) in 60 hours
2. Use [PICO-8](https://www.lexaloffle.com/dl/docs/pico-8_manual.html) as my game engine
3. Post each completed cart on the [Lexaloffle PICO-8 forum](https://www.lexaloffle.com/bbs/?cat=7) for feedback
4. Track hours and progress in a simple [devlog](/docs/devlog.md)
5. Revisit the scope and constraints for games 11-20 after completing 1-10

My goal is to learn and practice more "professional" patterns (forward thinking, extensible code) in game programming while balancing the need to ship actual games.



## Requirements

- [PICO-8](https://www.lexaloffle.com/pico-8.php)
- Git (duh)

## Project Structure

```plaintext
breakout/
├── art/                   # Mockups, custom colors
├── docs/                  # Lightweight notes and documentation
├── src/                   # Source code
│   ├── *.lua              # Various game "modules"
│   └── main.lua           # Entry point with _init, _update, _draw
├── flappy.p8              # Main P8 file; includes /src files
└── README.md              # Main project README
```

## Context Docs

- [20 Games Challege: Game 1](/docs/20-games-challenge.md): Outline of goals for this game from the 20 games challenge.
- [Dev Log](/docs/devlog.md): A simple tracking of what I worked on in each session.
