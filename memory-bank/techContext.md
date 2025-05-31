# Technical Context: Cubitos Dice Rolling Tray

## Technologies Used

### Tabletop Simulator (TTS)

- **Version**: Latest available
- **Platform**: Steam
- **Purpose**: Virtual tabletop environment for board game implementation

### Lua

- **Version**: Lua 5.2 (TTS's implementation)
- **Purpose**: Scripting language for game logic and object behavior
- **Documentation**: [TTS Lua API](https://api.tabletopsimulator.com/)

### XML

- **Purpose**: UI definition for buttons and panels
- **Documentation**: [TTS XML UI](https://api.tabletopsimulator.com/ui/introUI/)

## Development Setup

### Local Development

- Files are stored in the `.tts/objects/` directory
- Changes are synchronized with TTS when the game is loaded or reloaded
- Development workflow:
  1. Edit files in code editor
  2. Save changes
  3. Reload the game in TTS to see changes

### File Structure

- `.tts/objects/`: Directory for editable game object files
  - `Global.lua`: Contains the main game logic
  - `Global.xml`: Contains the UI definition
  - `*.data.json`: Object definitions for dice and tray
  - `*.lua`: Object-specific scripts
  - `*.xml`: Object-specific UI
- `.tts/bundled/`: Directory for automatically generated files
  - **IMPORTANT**: Never write files directly to this directory; they are created automatically by TTS

## Technical Constraints

### TTS Limitations

- Limited UI capabilities compared to web or native applications
- Physics simulation can be unpredictable
- Performance considerations with complex scripts
- Limited debugging capabilities

### Lua Constraints

- TTS uses a modified version of Lua with specific API functions
- No external libraries or modules can be imported
- Limited error reporting and debugging tools

### Object Interaction

- Objects must be properly identified by name, GUID, or other properties
- Physics interactions can cause unexpected behavior
- Need to account for network latency in multiplayer games

## Tool Usage Patterns

### Object Identification

```lua
-- Find objects by name
local allObjects = getAllObjects()
for _, obj in ipairs(allObjects) do
    local name = obj.getName()
    if name == "1" or name == "2" or name == "3" then
        -- Found a die
    end
end
```

### Event Handling

```lua
-- Button click event
function rollDice()
    -- Handle button click
end
```

### Delayed Execution

```lua
-- Wait for physics to settle
Wait.time(function()
    -- Code to execute after delay
end, 2) -- 2 second delay
```

### Object Manipulation

```lua
-- Move object smoothly
object.setPositionSmooth({x = 0, y = 1, z = 0})
```

## Dependencies

### External Assets

- Custom 3D models for dice and tray
- Custom textures for dice faces

### TTS Built-in Functions

- `getAllObjects()`: Get all objects in the scene
- `getName()`: Get the name of an object
- `randomize()`: Roll a die
- `getValue()`: Get the current value of a die
- `setPositionSmooth()`: Move an object with animation
- `Wait.time()`: Execute a function after a delay
