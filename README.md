# Cubitos Dice Rolling Tray

A Tabletop Simulator implementation of a dice rolling tray for the board game Cubitos.
Mod link: https://steamcommunity.com/sharedfiles/filedetails/?id=3556290779

## Overview

This project implements a dice rolling tray for the board game Cubitos in Tabletop Simulator. The tray allows players to roll dice and automatically separates them based on whether they show symbol faces or empty faces.

## Features

- Roll multiple dice with a single button click
- Automatic separation of dice based on whether they show symbol faces or empty faces
- **Flexible die naming system** supporting both single-digit and composite names
- Bust probability calculation and display with color coding
- Independent dice trays (cloned trays work independently)
- Organized grid layout for sorted dice
- Dynamic dice roll detection (no fixed wait times)
- Configurable logging system

## Project Structure

```
cubitos/
├── .tts/                # Tabletop Simulator files
│   ├── objects/         # Editable game object files
│   └── bundled/         # Automatically generated files (ignored by git)
├── lib/                 # Library files
│   └── DiceTrayLib.lua  # Core dice tray functionality
└── memory-bank/         # Project documentation
```

## Development

### Setup

1. Clone this repository
2. Edit files in the `.tts/objects/` directory
3. Never write files directly to the `.tts/bundled/` directory; they are created automatically by TTS

### Workflow

1. Edit files in code editor
2. Save changes
3. Reload the game in TTS to see changes

## Dice System

The dice tray supports a flexible naming system for dice with two different approaches:

### Single-Digit Names (Traditional)

- Each die is named with a single number (1-6) representing how many faces have symbols
- The remaining faces are empty
- Examples:
  - Die "1": Symbol on face 1, empty on faces 2-6 (83% bust probability)
  - Die "2": Symbols on faces 1-2, empty on faces 3-6 (67% bust probability)
  - Die "3": Symbols on faces 1-3, empty on faces 4-6 (50% bust probability)

### Multi-Digit Names (Enhanced)

- Each die can be named with multiple digits representing specific faces with symbols
- Each digit must be a valid face number (1-6) with no duplicates
- Examples:
  - Die "234": Symbols on faces 2, 3, 4, empty on faces 1, 5, 6 (50% bust probability)
  - Die "35": Symbols on faces 3, 5, empty on faces 1, 2, 4, 6 (67% bust probability)
  - Die "123456": Symbols on all faces (0% bust probability)

### Invalid Names (Rejected)

- "7" - Invalid face number
- "33" - Duplicate digits
- "" - Empty string
- "0" - Invalid face number

### Face Detection Logic

- **Single-digit**: If rolled value ≤ die name number, it's a symbol face
- **Multi-digit**: If rolled value appears in the die name string, it's a symbol face

## Probability Display

The tray displays real-time "Bust Probability" (chance all dice land on empty faces):

- **Green (≤20%)**: Good odds for the player
- **Red (≥80%)**: Bad odds for the player
- **White (21-79%)**: Medium odds

The probability updates automatically when dice are added, removed, or rolled.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue for bugs, feature requests, or improvements.
