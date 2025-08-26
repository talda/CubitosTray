--[[ Lua code for Dice Tray. See documentation: https://api.tabletopsimulator.com/ --]]

-- Import the Dice Tray Library
local DiceTrayLib = require("lib.DiceTrayLib")

-- Track dice in the tray
local diceInTray = {}
-- Logging flag
local loggingEnabled = false

-- The onLoad event is called after the game save finishes loading
function onLoad()
    -- Initialize the tray using the library
    diceInTray, loggingEnabled = DiceTrayLib.initializeTray(self)
    
    -- Initialize any needed variables or state
    Wait.time(function()
        DiceTrayLib.updateProbabilityDisplay(self, diceInTray, loggingEnabled)
    end, 1) -- Update probability display after 1 second
end

-- Function called when the Roll Dice button is clicked
function rollDice()
    -- Check if logging is enabled via the tray's description (in case it was changed since loading)
    loggingEnabled = (self.getDescription() == "log")
    
    -- Use the library to roll dice
    diceInTray = DiceTrayLib.rollDice(self, diceInTray, loggingEnabled)
end

-- Called when an object collides with the dice tray
function onCollisionEnter(collision_info)
    -- Check if logging is enabled via the tray's description (in case it was changed)
    loggingEnabled = (self.getDescription() == "log")
    
    -- Use the library to handle collision enter
    diceInTray = DiceTrayLib.onCollisionEnter(self, collision_info, diceInTray, loggingEnabled)
end

-- Called when an object stops colliding with the dice tray
function onCollisionExit(collision_info)
    -- Check if logging is enabled via the tray's description (in case it was changed)
    loggingEnabled = (self.getDescription() == "log")
    
    -- Use the library to handle collision exit
    diceInTray = DiceTrayLib.onCollisionExit(self, collision_info, diceInTray, loggingEnabled)
end

-- The onUpdate event is called once per frame
function onUpdate()
    -- Not needed for this implementation
end
