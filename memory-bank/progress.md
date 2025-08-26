# Progress: Cubitos Dice Rolling Tray

## Current Status

**Status**: Enhanced die validation system with composite die name support, ready for testing

## What Works

- ✅ UI button for rolling dice
- ✅ Button positioned to the left of the dice tray
- ✅ Button attached to the Dice Tray object
- ✅ Enhanced dice detection supporting both single-digit and composite names
- ✅ Dice rolling functionality
- ✅ Dual face detection logic (single vs multi-digit names)
- ✅ Improved sorting logic with organized grid layout
- ✅ Basic documentation in memory bank
- ✅ Bust probability display with color coding and automatic updates
- ✅ Independent dice trays (cloned trays work independently)
- ✅ Code bundling with library for improved maintainability
- ✅ Flexible die naming system (supports "1", "234", "35", etc.)

## What's Left to Build

- ⬜ Visual indicators for symbol and empty zones
- ⬜ Reset button functionality
- ⬜ Counter for dice in each category
- ⬜ Configuration options for wait time and positions
- ⬜ Testing with various dice configurations

## Implementation Timeline

| Date         | Milestone                                                              | Status      |
| ------------ | ---------------------------------------------------------------------- | ----------- |
| May 31, 2025 | Initial implementation                                                 | ✅ Complete |
| May 31, 2025 | Bug fix                                                                | ✅ Complete |
| May 31, 2025 | UI improvement                                                         | ✅ Complete |
| May 31, 2025 | Architecture improvement                                               | ✅ Complete |
| May 31, 2025 | Development process update                                             | ✅ Complete |
| May 31, 2025 | Button size update                                                     | ✅ Complete |
| May 31, 2025 | Bust probability display with color coding and automatic updates added | ✅ Complete |
| May 31, 2025 | Fixed probability display updates when dice are added/removed          | ✅ Complete |
| May 31, 2025 | Improved dice sorting with organized grid layout                       | ✅ Complete |
| May 31, 2025 | Added dice value preservation during movement                          | ✅ Complete |
| May 31, 2025 | Added dice repositioning for more accurate placement                   | ✅ Complete |
| May 31, 2025 | Updated bust probability color coding (green=good, red=bad)            | ✅ Complete |
| May 31, 2025 | Implemented configurable logging system                                | ✅ Complete |
| May 31, 2025 | Enhanced logging system with real-time toggle capability               | ✅ Complete |
| May 31, 2025 | Implemented dynamic dice roll detection                                | ✅ Complete |
| May 31, 2025 | Made dice trays independent when cloned                                | ✅ Complete |
| May 31, 2025 | Implemented code bundling with library                                 | ✅ Complete |
| Aug 26, 2025 | Enhanced die validation system with composite name support             | ✅ Complete |
| TBD          | Testing and refinement                                                 | ⬜ Pending  |
| TBD          | Additional features                                                    | ⬜ Pending  |

## Known Issues

- ✅ Fixed: Script error with `getNickname()` method (replaced with `getName()`)
- ✅ Fixed: Incorrectly writing files to bundled directory (now only writing to objects directory)
- ✅ Fixed: Probability display not updating when dice are added or removed from the tray
- None currently identified, pending testing

## Evolution of Project Decisions

### Initial Design (May 31, 2025)

- Decided to use dice names to encode the number of symbol faces
- Chose fixed positions for symbol and empty zones
- Set wait time to 2 seconds for dice to settle

### Bug Fix (May 31, 2025)

- Changed from using `getNickname()` to `getName()` to fix script error
- Updated all documentation to reflect the correct method usage
- Confirmed that dice identification logic remains the same, just using the correct method

### UI Improvement (May 31, 2025)

- Repositioned the "Roll Dice" button to be located to the left of the dice tray
- Initially adjusted button size to 120x30 for better visibility (later doubled to 240x60)
- Button positioned at coordinates {x = 1.5, y = 1.0, z = -2.2}

### Architecture Improvement (May 31, 2025)

- Moved the "Roll Dice" button from Global.xml to the Dice Tray object
- Moved dice rolling and sorting logic from Global.lua to the Dice Tray object
- Created Dice Tray object files (XML, Lua, and data.json)
- Simplified Global.lua and Global.xml files
- Button now positioned at {x = -2.0, y = 0.5, z = 0} relative to the tray

### Development Process Update (May 31, 2025)

- Established rule: Never write files to the `.tts/bundled/` directory
- Updated documentation to clarify that bundled files are created automatically by TTS
- Restored accidentally deleted files in the objects directory
- Updated memory bank documentation with new file structure information

### Button Size Update (May 31, 2025)

- Doubled the "Roll Dice" button size from 120x30 to 240x60
- Updated button defaults in the Dice Tray XML file
- Improved button visibility and usability for better player experience

### Probability Display Addition (May 31, 2025)

- Added a text UI element above the roll button to display "Bust Probability" information
- Implemented calculation logic for determining the probability of all dice landing on empty faces
- Formula: For each die, empty face probability = (6 - symbolFaceCount) / 6, then multiply all probabilities
- Display updates automatically in multiple scenarios:
  - When dice are detected during initial load
  - After dice are rolled and sorted
  - When dice are added to the tray (using onCollisionEnter)
  - When dice are removed from the tray (using onCollisionExit)
- Added Text element defaults to the XML UI configuration
- Implemented color coding for probability values:
  - Green for low probability (20% or less) - good for player
  - Red for high probability (80% or more) - bad for player
  - White for medium probability (21% to 79%)
- Increased font size from 14 to 20 for better readability

### Probability Display Fix (May 31, 2025)

- Fixed issue where probability wasn't updating correctly when dice were added or removed
- Implemented a dice tracking system using a table indexed by dice GUIDs
- Updated the probability calculation to only use dice that are currently in the tray
- Ensured the tracking table is properly updated in all scenarios:
  - When the tray is loaded (onLoad)
  - When dice are rolled (rollDice)
  - When dice enter the tray (onCollisionEnter)
  - When dice exit the tray (onCollisionExit)
- Added validation to handle cases where dice objects no longer exist

### Dice Sorting Improvement (May 31, 2025)

- Replaced random positioning with an organized grid layout
- Grouped dice by color (die type) for better visual organization
- Positioned empty dice on the left side and symbol dice on the right side
- Arranged dice in rows of 2 with consistent spacing
- Implemented sorting to keep dice of the same type together
- Added value preservation to prevent dice values from changing when moved
- Added repositioning after value restoration for more accurate placement

### Logging System Implementation (May 31, 2025)

- Disabled debug logging by default for cleaner operation in normal gameplay
- Added ability to enable logging by setting the tray's description to "log"
- Implemented a custom logging function that only prints messages when logging is enabled
- Updated all print statements to use the new logging system
- Added logging status message on load to confirm whether logging is enabled or disabled
- Enhanced logging system to check status in all major functions (rollDice, checkDiceResults, etc.)
- Enabled real-time toggling of logging by changing the tray's description during gameplay

### Dynamic Dice Roll Detection (May 31, 2025)

- Replaced fixed wait time with dynamic detection of when dice have finished rolling
- Implemented a monitoring system that checks dice status every 0.2 seconds
- Uses the `resting` property to determine if dice have stopped moving
- Automatically proceeds with sorting once all dice have stopped rolling
- Added a 5-second maximum wait time as a fallback in case dice get stuck
- Improved responsiveness by eliminating unnecessary waiting when dice settle quickly
- Added detailed logging of dice roll status and timing information

### Bundling Implementation (May 31, 2025)

- Moved all dice tray functionality to a separate library file (`lib/DiceTrayLib.lua`)
- Implemented bundling using the `require` function to load the library
- Simplified the main Dice Tray script by delegating functionality to the library
- Made the code more maintainable and reusable
- Ensured all tray instances use the same library code
- Maintained all existing functionality while improving code organization
- Reduced the main script from ~300 lines to ~40 lines
- Created a modular architecture that's easier to extend and maintain

### Tray Independence Implementation (May 31, 2025)

- Modified the dice tray script to make cloned trays fully independent
- Changed the `rollDice()` function to only roll dice that are physically in that specific tray
- Enhanced the `onLoad()` function to detect dice already in the tray when loading
- Ensured each tray only tracks and affects its own dice
- Fixed issue where pressing roll would roll dice in all trays simultaneously
- Maintained the collision detection system to properly track dice entering and exiting each tray
- Used proximity-based detection to find dice that are already in the tray when loading

### Enhanced Die Validation System (Aug 26, 2025)

- Replaced hardcoded die name validation with flexible system supporting composite names
- Implemented `isDie()` function that validates both single-digit ("1", "2", "3") and multi-digit ("234", "35") names
- Added validation rules:
  - Each character must be a valid face number (1-6)
  - No duplicate digits allowed (e.g., "33" is invalid)
  - Empty strings are rejected
- Updated face detection logic with dual system:
  - Single digit: Uses existing logic `(value <= symbolFaceCount)`
  - Multi digit: Uses string search `string.find(nickname, tostring(value))`
- Enhanced probability calculation to handle both naming systems:
  - Single digit: `symbolFaceCount = tonumber(nickname)` (numeric value)
  - Multi digit: `symbolFaceCount = #nickname` (string length)
- Maintained full backwards compatibility with existing single-digit dice
- Examples of supported die names:
  - "1": Symbol on face 1, empty on faces 2-6 (83% bust probability)
  - "234": Symbols on faces 2,3,4, empty on faces 1,5,6 (50% bust probability)
  - "35": Symbols on faces 3,5, empty on faces 1,2,4,6 (67% bust probability)
  - "123456": Symbols on all faces (0% bust probability)

## Testing Notes

### Test Cases to Verify

#### Single-Digit Die Names (Existing Functionality)

1. Die "1" shows symbol when face 1 is up, empty when faces 2-6 are up
2. Die "2" shows symbol when faces 1-2 are up, empty when faces 3-6 are up
3. Die "3" shows symbol when faces 1-3 are up, empty when faces 4-6 are up

#### Multi-Digit Die Names (New Functionality)

4. Die "234" shows symbol when faces 2, 3, or 4 are up, empty when faces 1, 5, or 6 are up
5. Die "35" shows symbol when faces 3 or 5 are up, empty when faces 1, 2, 4, or 6 are up
6. Die "123456" shows symbol on all faces (never empty)

#### Invalid Die Names (Should Be Rejected)

7. Die "7" should be rejected (invalid face number)
8. Die "33" should be rejected (duplicate digits)
9. Die "" should be rejected (empty string)
10. Die "0" should be rejected (invalid face number)

#### System Functionality

11. All valid dice are properly detected and rolled
12. Dice are correctly sorted after rolling based on their face results
13. Button is properly positioned relative to the dice tray
14. Button functionality works when attached to the Dice Tray object

#### Probability Display Testing

15. Bust probability display shows correct values and colors for different dice combinations:

    - Single-digit examples:
      - Die "1": 5/6 (83%) displayed in red
      - Die "2": 4/6 (67%) displayed in white
      - Die "3": 3/6 (50%) displayed in white
    - Multi-digit examples:
      - Die "234": 3/6 (50%) displayed in white
      - Die "35": 4/6 (67%) displayed in white
      - Die "123456": 0/6 (0%) displayed in green
    - Mixed combinations:
      - Die "1" + Die "234": 5/6 \* 3/6 (42%) displayed in white
      - Three dice "35": (4/6)³ (30%) displayed in white

16. Bust probability updates automatically when dice are added or removed from the tray
    - Add a die to the tray and verify the probability updates
    - Remove a die from the tray and verify the probability updates
    - Add multiple dice in sequence and verify the probability updates correctly after each addition

## Future Considerations

- Support for additional dice types
- Integration with other Cubitos game mechanics
- Customizable dice configurations
- Multiplayer synchronization improvements
- Additional UI elements attached to the Dice Tray object
