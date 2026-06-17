# Mountain Laser Tag

## Overview

**Mountain Laser Tag** is a 3D action game built in Godot where players battle through nighttime mountain arenas using laser weapons, upgrades, teamwork, and mission-based objectives. The game includes multiple modes, a progression system, achievements, money rewards, a shop, helicopters, AI teammates and enemies, and a final boss showdown.

The goal is to survive each mission, earn money, improve your gear, unlock achievements, and become strong enough to defeat the Final Boss.

---

## Game Modes

### Team Elimination

Fight alongside the Blue team and eliminate the Red team before they eliminate you.

### Capture the Flag

Steal the Red flag and return it to your base while defending your own flag.

### Manhunt

Survive as the hunted target or track down the hunted target as quickly as possible.

### Commander

Protect your commander while trying to eliminate the enemy commander.

### King of the Hill

Control the hill zone longer than the Red team to win the match.

### Final Showdown

Face the Final Boss in a major endgame battle. Blue CPUs can help weaken the boss, but the player must finish the fight.

---

## Features

* 3D mountain battlefield
* Laser tag combat system
* AI teammates and enemies
* Multiple game modes
* Helicopter gameplay
* Upgrade shop
* Money reward system
* Mode-specific rewards
* Achievement system
* Final Boss battle
* Final credits and save-finish screen
* Main menu with mission brief system
* Browser-friendly save behavior

---

## Controls

| Action               | Key               |
| -------------------- | ----------------- |
| Move                 | WASD              |
| Look Around          | Mouse             |
| Shoot                | Left Mouse Button |
| Sprint               | Shift             |
| Jump                 | Space             |
| Reload / Refill Ammo | Q                 |
| Open Shop            | U                 |
| Confirm              | Enter             |
| Cancel / Back        | Escape            |

---

## Progression

Players earn money by completing objectives, getting eliminations, surviving certain modes, capturing flags, controlling the hill, and defeating major challenges. Money can be spent in the upgrade shop to improve player abilities.

Upgrades include:

* Sprint speed
* Stamina
* Stamina regeneration
* Health
* Helicopter fuel
* Fire rate
* Reload speed
* Ammo capacity

---

## Achievements

The game includes achievements for combat, objectives, upgrades, mode wins, helicopter use, Manhunt survival, Capture the Flag wins, King of the Hill wins, and Final Boss completion. Some achievements are hidden until unlocked, giving players extra goals to discover while playing.

---

## Final Boss

The Final Boss is the endgame challenge. It has high health, multiple attack patterns, and a special victory flow. After winning, the game saves the player’s completion reward and shows an ending screen instead of closing the browser window.

---

## Save System

The game uses Godot’s local save system. In a browser build, saves are stored locally in the player’s browser. This means save data usually stays on the same computer, browser, and website link, but it may not transfer to another device or browser.

---

## Development Notes

This project was built and improved through testing, debugging, and repeated design changes. Several systems were adjusted after testing, including the final boss, money rewards, achievements, mission brief menu, reset behavior, and performance settings. Some visual ideas, such as heavy edge fog, were removed because they caused too much lag.

---

## AI Disclosure

I used AI to help with coding, fixing errors, and writing parts of my dev log. I tested the game myself, made the design choices, and changed things when they did not work. AI helped me, but this project is still my work.

---

## Built With

* Godot Engine
* GDScript

---

## Project Status

Mountain Laser Tag is playable and includes multiple modes, progression, achievements, and an endgame boss. The project may still need more testing, balancing, and bug fixes, especially for browser performance.
