# Project Brief: Cubitos Dice Rolling Tray

## Overview

This project implements a dice rolling tray for the board game Cubitos in Tabletop Simulator. The tray allows players to roll dice and automatically separates them based on whether they show symbol faces or empty faces.

## Core Requirements

1. **Dice System**:

   - Each die is named with a number (1-6) representing how many faces have symbols
   - The remaining faces are empty
   - Example: Die "3" has 3 faces with symbols (faces 1-3) and 3 faces empty (faces 4-6)

2. **Functionality**:
   - A button to roll all dice at once
   - Automatic separation of dice after rolling:
     - Dice showing symbol faces go to one area
     - Dice showing empty faces go to another area

## Technical Implementation

1. **UI Components**:

   - Roll button in the XML UI

2. **Lua Scripting**:
   - Function to detect all dice in the tray
   - Roll animation/physics trigger
   - Face detection after dice settle
   - Automatic movement to appropriate zones

## Project Structure

```
cubitos/
├── memory-bank/          # Documentation
├── .tts/
│   └── objects/
│       ├── Global.lua    # Main game logic
│       ├── Global.xml    # UI elements
│       ├── 1.*.data.json # Die 1 (1 symbol face)
│       ├── 2.*.data.json # Die 2 (2 symbol faces)
│       ├── 3.*.data.json # Die 3 (3 symbol faces)
│       └── Dice Tray.*   # Tray object
```
