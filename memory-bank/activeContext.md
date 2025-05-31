# Active Context: Cubitos Dice Rolling Tray

## Current Work Focus

We are implementing a dice rolling tray for the board game Cubitos in Tabletop Simulator. The primary functionality is to:

1. Roll multiple dice with a single button click
2. Automatically separate dice based on whether they show symbol faces or empty faces

## Recent Changes

### Bundling Implementation (May 31, 2025)

- Moved all dice tray functionality to a separate library file (`lib/DiceTrayLib.lua`)
- Implemented bundling using the `require` function to load the library
- Simplified the main Dice Tray script by delegating functionality to the library
- Made the code more maintainable and reusable
- Ensured all tray instances use the same library code
- Maintained all existing functionality while improving code organization

### Tray Independence Update (May 31, 2025)

- Modified the dice tray script to make cloned trays fully independent
- Changed the `rollDice()` function to only roll dice that are physically in that specific tray
- Enhanced the `onLoad()` function to detect dice already in the tray when loading
- Ensured each tray only tracks and affects its own dice
- Fixed issue where pressing roll would roll dice in all trays simultaneously
- Maintained the collision detection system to properly track dice entering and exiting each tray

### Logging System Update (May 31, 2025)

- Disabled debug logging by default for cleaner operation
- Added ability to enable logging by setting the tray's description to "log"
- Implemented a custom logging function that only prints messages when logging is enabled
- Updated all print statements to use the new logging system
- Added logging status checks in all major functions to allow real-time toggling of logging

### Initial Implementation (May 31, 2025)

- Created UI button in Global.xml
- Implemented dice rolling and sorting logic in Global.lua
- Set up memory bank documentation

### Bug Fix (May 31, 2025)

- Changed `getNickname()` to `getName()` to fix script error
- Updated documentation to reflect the correct method usage

### UI Improvement (May 31, 2025)

- Repositioned the "Roll Dice" button to be located to the left of the dice tray
- Adjusted button size for better visibility and usability

### Architecture Improvement (May 31, 2025)

- Moved the "Roll Dice" button from Global.xml to the Dice Tray object
- Moved dice rolling and sorting logic from Global.lua to the Dice Tray object
- Created Dice Tray object files (XML, Lua, and data.json)
- Simplified Global.lua and Global.xml files

### Development Process Update (May 31, 2025)

- Established rule: Never write files to the `.tts/bundled/` directory
- Updated documentation to clarify that bundled files are created automatically by TTS
- Restored accidentally deleted files in the objects directory

### Button Size Update (May 31, 2025)

- Doubled the "Roll Dice" button size from 120x30 to 240x60
- Updated button defaults in the Dice Tray XML file
- Improved button visibility and usability

### Probability Display Addition (May 31, 2025)

- Added a text display above the roll button showing the "Bust Probability" (probability of all dice landing on empty faces)
- Implemented calculation logic that accounts for different dice types (1, 2, or 3 symbol faces)
- Display updates automatically when:
  - Dice are detected during initial load
  - After dice are rolled and sorted
  - When dice are added to the tray (using onCollisionEnter)
  - When dice are removed from the tray (using onCollisionExit)
- Added color coding for probability values:
  - Green for low probability (20% or less) - good for player
  - Red for high probability (80% or more) - bad for player
  - White for medium probability (21% to 79%)
- Used larger font size (20) for better readability

### Probability Display Fix (May 31, 2025)

- Fixed issue where probability wasn't updating correctly when dice were added or removed
- Implemented a tracking system to keep track of dice in the tray
- Used a table indexed by dice GUIDs to track which dice are currently in the tray
- Updated the probability calculation to use only the tracked dice
- Ensured the tracking table is properly updated when:
  - The tray is loaded
  - Dice are rolled
  - Dice enter the tray
  - Dice exit the tray

## Active Decisions

### Dice Identification

- Dice are identified by their names ("1", "2", "3")
- The name represents the number of faces with symbols
- For example, die "2" has symbols on faces 1-2 and empty faces 3-6

### Sorting Logic

- Dice are now arranged in a grid pattern, grouped by color (die type)
- Empty dice are positioned on the left side at {x = 1, y = 1, z = 1}
- Symbol dice are positioned on the right side at {x = 5, y = 1, z = 1}
- Dice are arranged in rows of 2 with 1 unit spacing between them
- Dice of the same type (color) are kept together for better visual organization
- Die values are preserved during movement to prevent value changes when repositioning
- Dice are repositioned after value restoration for more accurate placement

### Button Positioning

- Button is now part of the Dice Tray object
- Button is positioned at {x = -2.0, y = 0.5, z = 0} relative to the tray
- Button size is set to 240x60 for better visibility (doubled from previous 120x30)

### Dice Rolling Detection

- Implemented dynamic detection of when dice have finished rolling
- Uses the `resting` property to check if dice have stopped moving
- Checks dice status every 0.2 seconds
- Proceeds with sorting once all dice have stopped moving
- Includes a 5-second maximum wait time as a fallback

### File Structure

- Only edit files in the `.tts/objects/` directory
- Never write to the `.tts/bundled/` directory as these files are generated automatically

## Next Steps

### Testing

- Test with different dice configurations
- Verify that face detection works correctly
- Ensure dice are properly sorted
- Verify button position is correct relative to the tray

### Potential Improvements

1. **Visual Feedback**:

   - Add visual indicators for symbol and empty zones
   - Consider adding text labels or highlighting

2. **Configuration Options**:

   - Allow customization of wait time
   - Make zone positions configurable

3. **Additional Features**:
   - Add a reset button to return dice to starting positions
   - Add a counter to display the number of dice in each category

## Learnings and Insights

- TTS's dice physics require sufficient wait time before checking results
- Using the object name as a way to encode die properties is an efficient approach
- The `setPositionSmooth()` function provides a better user experience than instant movement
- TTS API methods must be used correctly (`getName()` instead of `getNickname()`)
- UI element positioning should be relative to game objects for better user experience
- Attaching UI elements and logic to relevant game objects improves code organization
- TTS maintains a bundled directory with automatically generated files that should not be manually edited
