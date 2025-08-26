# Cubitos Dice Rolling Tray

A Tabletop Simulator implementation of a dice rolling tray for the board game Cubitos.
Mod link: https://steamcommunity.com/sharedfiles/filedetails/?id=3556290779

## Overview

This project implements a dice rolling tray for the board game Cubitos in Tabletop Simulator. The tray allows players to roll dice and automatically separates them based on whether they show symbol faces or empty faces.

## Features

- Roll multiple dice with a single button click
- Automatic separation of dice based on whether they show symbol faces or empty faces
- Bust probability calculation and display
- Independent dice trays (cloned trays work independently)
- Organized grid layout for sorted dice

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

- Each die is named with a number (1-6) representing how many faces have symbols
- The remaining faces are empty
- Example: Die "3" has 3 faces with symbols (faces 1-3) and 3 faces empty (faces 4-6)
