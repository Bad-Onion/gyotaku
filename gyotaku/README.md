# Project Structure

The project is organized into the following directories:

```Plaintext
res://
├── assets/                 # Globally shared assets (NOT scene-specific)
│   ├── fonts/
│   ├── audio/
|   ├── sprites/            # Global sprites that aren't tied to a specific entity
│   └── sfx/                # Generic UI clicks, etc.
|
├── core/                   # Game-wide systems and utilities
│   ├── event_bus.gd        # Global signal manager
│   └── audio_manager.tscn  # Background music player
|
├── scenes/                 # Entities/Scenes separated by domain
│   ├── player/             # Everything related to the player
│   │   ├── player.gd       # Player script
│   │   ├── player.tscn     # Player scene (can be instanced in levels)
│   │   ├── resources/      # Player-specific assets (sprites, animations, etc.)
│   │   └── states/         # Player state machine scripts (idle, run, jump, etc.)
|   |
│   ├── enemies/
│   │   ├── base_enemy/     # Inheritable base class (if needed)
│   │   └── random_enemy/   # Scene, script, and art all in one place
│   │       ├── random_enemy.gd
│   │       ├── random_enemy.tscn
|   │       ├── resources/
│   │       └── states/
|   │
│   ├── levels/             # Level scenes
│   │   └── level_1.tscn
|   |
│   ├── interactables/
│   │   ├── door/
│   │   └── coin/
|   |
│   └── ui/
│       ├── main_menu/
│       └── hud/
|
├── scripts/                # Misc scripts that don't belong to a specific scene
│   ├── utilities/
|   └── services/           # E.g. save/load system, audio service, etc.
|
└── main.tscn               # The root entry point
```
