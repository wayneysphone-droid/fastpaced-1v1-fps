# FastPaced 1v1 FPS

A fast-paced, skill-based first-person shooter emphasizing rapid movement and gunplay mastery over loadouts. Players unlock and master 40+ distinct weapons in quick-fire 1v1 rounds.

## Core Features

- **Dynamic Movement**: Slide-jumping, dashing, and momentum-based mechanics
- **Weapon Mastery**: 40+ unique weapons with distinct playstyles
- **Skill-Based Combat**: Precision aiming and movement outweigh gear
- **Fast Rounds**: Quick-paced 1v1 matches designed for competitive play

## Weapon Categories

### Rifles
- **Sniper** - High-skill, high-reward precision weapon
- **Assault Rifle** - Reliable mid-range automatic
- **Burst Rifle** - Controlled bursts rewarding accuracy
- **Energy Rifle** - Sci-fi laser rifle with precision

### Shotguns & Close-Range
- **Shotgun** - Close-range health chunk
- **Gunblade** - Hybrid melee/ranged switch weapon

### Heavy Weapons
- **Minigun** - High magazine, reduced mobility
- **Flamethrower** - Constant close-range fire damage
- **RPG** - Direct-impact rockets (lead shots)

### Projectiles & Utility
- **Grenade Launcher** - Bouncing explosives for area control
- **Bow** - Charged arrows + mobility jump
- **Crossbow** - Mid-to-long range tracking
- **Paintball Gun** - Rapid-fire tracking pressure

### Special Weapons
- **Distortion** - Splash projectiles + vortex trap
- **Permafrost** - Ice rifle with freeze slow

## Project Structure

```
fastpaced-1v1-fps/
├── scenes/
│   ├── game/
│   │   └── main_match.tscn
│   ├── player/
│   │   ├── player.tscn
│   │   └── camera_controller.tscn
│   ├── weapons/
│   │   └── [weapon scenes]
│   ├── maps/
│   │   └── [arena maps]
│   └── ui/
│       ├── hud.tscn
│       └── match_end.tscn
├── scripts/
│   ├── core/
│   │   ├── player_controller.gd
│   │   ├── weapon_manager.gd
│   │   └── game_manager.gd
│   ├── weapons/
│   │   ├── weapon_base.gd
│   │   ├── rifle_weapons.gd
│   │   ├── shotgun_weapons.gd
│   │   ├── heavy_weapons.gd
│   │   ├── projectile_weapons.gd
│   │   └── special_weapons.gd
│   ├── movement/
│   │   ├── movement_controller.gd
│   │   ├── slide_dash_system.gd
│   │   └── camera_controller.gd
│   ├── combat/
│   │   ├── damage_calculator.gd
│   │   ├── hitbox_system.gd
│   │   └── projectile_handler.gd
│   └── ui/
│       ├── hud_controller.gd
│       └── match_manager.gd
├── assets/
│   ├── audio/
│   ├── models/
│   └── textures/
├── data/
│   └── weapon_balance.json
└── project.godot
```

## Development Roadmap

- [ ] Core player controller (movement + camera)
- [ ] Weapon system architecture
- [ ] Weapon balance implementation
- [ ] Basic combat loop (firing + damage)
- [ ] 1v1 match manager
- [ ] Map prototypes
- [ ] UI/HUD system
- [ ] Sound & visual effects
- [ ] Weapon unlock progression
- [ ] Competitive features (ranked, stats)

## Tech Stack

- **Engine**: Godot 4.2+
- **Language**: GDScript
- **Physics**: Godot Physics 3D
- **Audio**: Godot Audio System

## Getting Started

1. Clone the repository
2. Open in Godot 4.2+
3. Run the main scene (`res://scenes/game/main_match.tscn`)
4. Begin development on core mechanics

---

*Built with Godot Engine | Fast-Paced Competitive FPS*