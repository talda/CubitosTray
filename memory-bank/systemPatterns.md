# System Patterns: Cubitos Dice Rolling Tray

## System Architecture

The Cubitos Dice Rolling Tray is built on Tabletop Simulator's scripting system, which uses Lua for game logic and XML for UI elements. The architecture follows a modular, library-based pattern with bundling:

```
┌─────────────┐     ┌───────────────────────────────────────┐
│  UI Button  │────▶│           Dice Tray Object            │
└─────────────┘     │                                       │
                    │  ┌─────────────┐                      │
                    │  │ require()   │                      │
                    │  └──────┬──────┘                      │
                    └──────────┼──────────────────────────┬─┘
                               │                          │
                               ▼                          │
                    ┌─────────────────────┐               │
                    │   DiceTrayLib.lua   │               │
                    │                     │               │
                    │  ┌───────────────┐  │               │
                    │  │  Roll Logic   │──┼───────────────┘
                    │  └───────┬───────┘  │
                    │          │          │
                    │          ▼          │
                    │  ┌───────────────┐  │
                    │  │  Sort Logic   │  │
                    │  └───────────────┘  │
                    └─────────────────────┘
```

## Key Components

## Key Components

### 1. UI Layer (Dice Tray XML)

- **Button Component**: A simple button that triggers the dice rolling action
- **Panel Container**: Holds the button and is positioned relative to the tray
- **Probability Display**: Text element showing the bust probability
- **Styling**: Enhanced styling for visibility and usability

### 2. Object Layer (Dice Tray.lua)

- **Minimal Script**: Lightweight script that uses the library
- **Event Handlers**: Handles button clicks and collision events
- **State Management**: Maintains tray-specific state (dice tracking)
- **Library Integration**: Uses `require()` to load the DiceTrayLib

### 3. Library Layer (DiceTrayLib.lua)

- **Object Detection**: Finds dice objects in the tray based on their names
- **Roll Mechanism**: Uses TTS's built-in randomization for dice
- **Face Detection**: Determines which face is showing on each die after rolling
- **Sorting Logic**: Separates dice based on whether they show symbol faces or empty faces
- **Movement Control**: Smoothly moves dice to their appropriate zones
- **Probability Calculation**: Computes and displays bust probability

## Design Patterns

### 1. Module Pattern

The system uses a module pattern to encapsulate functionality:

```lua
local DiceTrayLib = {}

-- Functions and constants defined here

return DiceTrayLib
```

### 2. Bundling Pattern

Uses TTS's bundling system with `require()` to load modular code:

```lua
local DiceTrayLib = require("lib.DiceTrayLib")
```

### 3. Event-Driven Architecture

The system uses TTS's event system to respond to user actions:

- `onLoad`: Initializes the system when the game loads
- Button click event: Triggers the dice rolling process
- Collision events: Track dice entering and exiting the tray

### 4. Dynamic Monitoring Pattern

Uses a monitoring loop to check when dice have stopped rolling:

```lua
monitoringId = Wait.time(checkDiceStatus, CHECK_INTERVAL, -1)
```

### 5. Dependency Injection Pattern

The library functions accept the tray object as a parameter:

```lua
function DiceTrayLib.rollDice(tray, diceInTray, loggingEnabled)
```

### 3. Object Identification Pattern

Dice are identified by their names, which correspond to the number of symbol faces they have:

```lua
local nickname = obj.getName()
if nickname == "1" or nickname == "2" or nickname == "3" then
    table.insert(dice, obj)
end
```

## Data Flow

1. **User Input**: Player clicks the "Roll Dice" button on a specific tray
2. **Library Call**: Tray script calls the library's `rollDice` function
3. **Object Collection**: System identifies dice objects in that specific tray
4. **Randomization**: Dice are rolled using TTS physics
5. **Dynamic Monitoring**: System monitors dice until they stop moving
6. **Result Analysis**: Each die's face value is checked
7. **Classification**: Dice are classified as showing symbol or empty face
8. **Sorting**: Dice are moved to appropriate zones relative to that tray
9. **Probability Update**: Bust probability is calculated and displayed

## Technical Decisions

### 1. Die Face Determination

We determine if a die shows a symbol face by comparing its value to the die's name:

```lua
local isSymbolFace = (value <= symbolFaceCount)
```

This works because:

- Die "1" has a symbol on face 1 only
- Die "2" has symbols on faces 1-2
- Die "3" has symbols on faces 1-3

### 2. Relative Positioning

Dice positions are calculated relative to the tray and then converted to world coordinates:

```lua
local relativePos = {
    x = SYMBOL_ZONE_POS.x + (symbolCol * GRID_SPACING),
    y = SYMBOL_ZONE_POS.y,
    z = SYMBOL_ZONE_POS.z - (symbolRow * GRID_SPACING)
}
local targetPos = tray.positionToWorld(relativePos)
```

### 3. Grid-Based Layout

Dice are arranged in a grid pattern, grouped by type:

```lua
symbolCol = symbolCol + 1
if symbolCol >= MAX_DICE_PER_ROW then
    symbolCol = 0
    symbolRow = symbolRow + 1
end
```

### 4. Value Preservation

Die values are preserved during movement to prevent value changes:

```lua
local currentValue = die.getValue()
die.setPositionSmooth(targetPos)
Wait.time(function()
    die.setValue(currentValue)
    die.setPositionSmooth(targetPos)
end, 0.5)
```

### 5. Bundling Architecture

The code is organized into a main script and a library:

- **Main Script**: Minimal code that handles events and delegates to the library
- **Library**: Contains all the core functionality in a reusable module
- **Bundling**: Uses TTS's bundling system to combine the files at runtime

This architecture provides:

- Better code organization
- Improved maintainability
- Reusability across multiple tray instances
- Easier debugging and extension
