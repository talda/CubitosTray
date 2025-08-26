--[[
Library for Dice Tray functionality

MIT License
Copyright (c) 2025 Tal Darom
See LICENSE file for full license text.
]]

local DiceTrayLib = {}

-- Constants for positions (relative to the tray)
DiceTrayLib.EMPTY_ZONE_POS = {x = -3.0, y = 1, z = 2.9}  -- Base position for dice with empty faces (left side)
DiceTrayLib.SYMBOL_ZONE_POS = {x = 0.5, y = 1, z = 2.9}   -- Base position for dice with symbols (right side)

-- Constants for dice arrangement
DiceTrayLib.GRID_SPACING = 0.75  -- Space between dice in the grid
DiceTrayLib.MAX_DICE_PER_ROW = 4  -- Maximum number of dice per row

-- Constants for dice rolling detection
DiceTrayLib.CHECK_INTERVAL = 0.2  -- How often to check if dice have stopped rolling (in seconds)
DiceTrayLib.MAX_WAIT_TIME = 5     -- Maximum time to wait for dice to settle (in seconds)

-- Helper function to check if an object is a valid die
-- Supports both single digits ("1", "2", "3") and composite names ("234", "35")
function DiceTrayLib.isDie(nickname)
    -- Check if string is non-empty
    if not nickname or nickname == "" then
        return false
    end
    
    -- Track seen digits to prevent duplicates
    local seenDigits = {}
    
    -- Check each character
    for i = 1, #nickname do
        local char = nickname:sub(i, i)
        local digit = tonumber(char)
        
        -- Must be a valid face number (1-6)
        if not digit or digit < 1 or digit > 6 then
            return false
        end
        
        -- Must not be a duplicate
        if seenDigits[digit] then
            return false
        end
        
        seenDigits[digit] = true
    end
    
    return true
end

-- Custom logging function that only prints if logging is enabled
function DiceTrayLib.log(message, isLoggingEnabled)
    if isLoggingEnabled then
        print(message)
    end
end

-- Initialize the dice tray
function DiceTrayLib.initializeTray(tray)
    -- Check if logging is enabled via the tray's description
    local loggingEnabled = (tray.getDescription() == "log")
    
    DiceTrayLib.log('Cubitos Dice Tray loaded! Logging is ' .. (loggingEnabled and 'enabled' or 'disabled'), loggingEnabled)
    
    -- Initialize the dice tracking table
    local diceInTray = {}
    
    -- Find dice that are already in the tray when loading
    -- We'll check for objects that are physically overlapping with the tray
    local bounds = tray.getBounds()
    local allObjects = getAllObjects()
    
    for _, obj in ipairs(allObjects) do
        local nickname = obj.getName()
        if DiceTrayLib.isDie(nickname) then
            -- Check if the die is inside or overlapping with the tray
            local diePos = obj.getPosition()
            local trayPos = tray.getPosition()
            
            -- Simple check if the die is close to the tray
            local dx = math.abs(diePos.x - trayPos.x)
            local dy = math.abs(diePos.y - trayPos.y)
            local dz = math.abs(diePos.z - trayPos.z)
            
            -- If the die is within a reasonable distance of the tray center, consider it in the tray
            -- This is a simplified check - adjust the threshold as needed
            local threshold = 3 -- Units in TTS world space
            if dx < threshold and dy < threshold and dz < threshold then
                DiceTrayLib.log("Found die in tray on load: " .. nickname, loggingEnabled)
                -- Add die to the tracking table
                diceInTray[obj.getGUID()] = obj
            end
        end
    end
    
    return diceInTray, loggingEnabled
end

-- Roll dice in the tray
function DiceTrayLib.rollDice(tray, diceInTray, loggingEnabled)
    DiceTrayLib.log('Rolling dice! Logging is ' .. (loggingEnabled and 'enabled' or 'disabled'), loggingEnabled)
    
    -- Only roll dice that are in this specific tray
    local dice = {}
    
    -- Collect all dice objects from the tracking table
    for guid, obj in pairs(diceInTray) do
        -- Make sure the object still exists
        if obj ~= nil and obj.getGUID ~= nil then
            table.insert(dice, obj)
            DiceTrayLib.log("Rolling die: " .. obj.getName(), loggingEnabled)
        else
            -- Object no longer exists, remove it from tracking
            diceInTray[guid] = nil
        end
    end
    
    -- Roll all dice in this tray
    for _, die in ipairs(dice) do
        die.randomize()
    end
    
    -- Start monitoring dice to detect when they've stopped rolling
    DiceTrayLib.startDiceMonitoring(tray, dice, diceInTray, loggingEnabled)
    
    return diceInTray
end

-- Check the results of the dice roll and sort them
function DiceTrayLib.checkDiceResults(tray, dice, diceInTray, loggingEnabled)
    -- Group dice by type and result
    local symbolDice = {}
    local emptyDice = {}
    
    -- First pass: categorize dice by result and color (nickname)
    for _, die in ipairs(dice) do
        local value = die.getValue()
        local nickname = die.getName()
        
        -- Check if the die landed on a symbol face or empty face
        local isSymbolFace
        if #nickname == 1 then
            -- Single digit: use existing logic (value <= symbolFaceCount)
            local symbolFaceCount = tonumber(nickname)
            isSymbolFace = (value <= symbolFaceCount)
        else
            -- Multi digit: check if rolled value is in the string
            isSymbolFace = string.find(nickname, tostring(value)) ~= nil
        end
        
        -- Add to appropriate group, organized by die type (nickname)
        if isSymbolFace then
            if not symbolDice[nickname] then
                symbolDice[nickname] = {}
            end
            table.insert(symbolDice[nickname], die)
        else
            if not emptyDice[nickname] then
                emptyDice[nickname] = {}
            end
            table.insert(emptyDice[nickname], die)
        end
        
        -- Log result for debugging
        local resultType = isSymbolFace and "symbol" or "empty"
        DiceTrayLib.log("Die " .. nickname .. " rolled a " .. value .. " (" .. resultType .. ")", loggingEnabled)
    end
    
    -- Second pass: position dice in a grid pattern, grouped by color
    local symbolDiceTypes = {}
    local emptyDiceTypes = {}
    
    -- Get sorted list of die types (for consistent ordering)
    for dieType in pairs(symbolDice) do
        table.insert(symbolDiceTypes, dieType)
    end
    for dieType in pairs(emptyDice) do
        table.insert(emptyDiceTypes, dieType)
    end
    table.sort(symbolDiceTypes)
    table.sort(emptyDiceTypes)
    
    -- Position symbol dice
    local symbolRow = 0
    local symbolCol = 0
    
    for _, dieType in ipairs(symbolDiceTypes) do
        for _, die in ipairs(symbolDice[dieType]) do
            -- Store the current value before moving
            local currentValue = die.getValue()
            
            -- Calculate position relative to the tray
            local relativePos = {
                x = DiceTrayLib.SYMBOL_ZONE_POS.x + (symbolCol * DiceTrayLib.GRID_SPACING),
                y = DiceTrayLib.SYMBOL_ZONE_POS.y,
                z = DiceTrayLib.SYMBOL_ZONE_POS.z - (symbolRow * DiceTrayLib.GRID_SPACING)
            }
            
            -- Convert to world position based on tray's position and rotation
            local targetPos = tray.positionToWorld(relativePos)
            
            -- Move the die to the appropriate position
            die.setPositionSmooth(targetPos)
            
            -- Wait a short time, then restore the original value and reposition for accuracy
            Wait.time(function()
                die.setValue(currentValue)
                -- Move the die to the same position again for more accurate placement
                die.setPositionSmooth(targetPos)
                DiceTrayLib.log("Restored symbol die value to: " .. currentValue .. " and repositioned", loggingEnabled)
            end, 0.5)
            
            -- Update grid position for next die
            symbolCol = symbolCol + 1
            if symbolCol >= DiceTrayLib.MAX_DICE_PER_ROW then
                symbolCol = 0
                symbolRow = symbolRow + 1
            end
        end
    end
    
    -- Position empty dice
    local emptyRow = 0
    local emptyCol = 0
    
    for _, dieType in ipairs(emptyDiceTypes) do
        for _, die in ipairs(emptyDice[dieType]) do
            -- Store the current value before moving
            local currentValue = die.getValue()
            
            -- Calculate position relative to the tray
            local relativePos = {
                x = DiceTrayLib.EMPTY_ZONE_POS.x + (emptyCol * DiceTrayLib.GRID_SPACING),
                y = DiceTrayLib.EMPTY_ZONE_POS.y,
                z = DiceTrayLib.EMPTY_ZONE_POS.z - (emptyRow * DiceTrayLib.GRID_SPACING)
            }
            
            -- Convert to world position based on tray's position and rotation
            local targetPos = tray.positionToWorld(relativePos)
            
            -- Move the die to the appropriate position
            die.setPositionSmooth(targetPos)
            
            -- Wait a short time, then restore the original value and reposition for accuracy
            Wait.time(function()
                die.setValue(currentValue)
                -- Move the die to the same position again for more accurate placement
                die.setPositionSmooth(targetPos)
                DiceTrayLib.log("Restored empty die value to: " .. currentValue .. " and repositioned", loggingEnabled)
            end, 0.5)
            
            -- Update grid position for next die
            emptyCol = emptyCol + 1
            if emptyCol >= DiceTrayLib.MAX_DICE_PER_ROW then
                emptyCol = 0
                emptyRow = emptyRow + 1
            end
        end
    end
    
    -- Update probability display after dice are sorted
    Wait.time(function()
        DiceTrayLib.updateProbabilityDisplay(tray, diceInTray, loggingEnabled)
    end, 0.5)
end

-- Handle collision enter event
function DiceTrayLib.onCollisionEnter(tray, collision_info, diceInTray, loggingEnabled)
    -- Check if the colliding object is a die
    local obj = collision_info.collision_object
    if obj ~= nil then
        local nickname = obj.getName()
        if DiceTrayLib.isDie(nickname) then
            DiceTrayLib.log("Die " .. nickname .. " entered the tray", loggingEnabled)
            -- Add die to the tracking table
            diceInTray[obj.getGUID()] = obj
            -- Update probability display after a short delay to ensure the die is settled
            Wait.time(function()
                DiceTrayLib.updateProbabilityDisplay(tray, diceInTray, loggingEnabled)
            end, 0.2)
        end
    end
    
    return diceInTray
end

-- Handle collision exit event
function DiceTrayLib.onCollisionExit(tray, collision_info, diceInTray, loggingEnabled)
    -- Check if the exiting object is a die
    local obj = collision_info.collision_object
    if obj ~= nil then
        local nickname = obj.getName()
        if DiceTrayLib.isDie(nickname) then
            DiceTrayLib.log("Die " .. nickname .. " exited the tray", loggingEnabled)
            -- Remove die from the tracking table
            diceInTray[obj.getGUID()] = nil
            -- Update probability display after a short delay
            Wait.time(function()
                DiceTrayLib.updateProbabilityDisplay(tray, diceInTray, loggingEnabled)
            end, 0.2)
        end
    end
    
    return diceInTray
end

-- Calculate and update the probability display
function DiceTrayLib.updateProbabilityDisplay(tray, diceInTray, loggingEnabled)
    local dice = {}
    local totalProbability = 1.0
    
    -- Use the tracked dice in the tray
    for guid, obj in pairs(diceInTray) do
        -- Make sure the object still exists
        if obj ~= nil and obj.getGUID ~= nil then
            local nickname = obj.getName()
            if DiceTrayLib.isDie(nickname) then
                table.insert(dice, obj)
                
                -- Calculate probability for this die
                local symbolFaceCount
                if #nickname == 1 then
                    -- Single digit: use the numeric value (existing logic)
                    symbolFaceCount = tonumber(nickname)
                else
                    -- Multi digit: use the string length (new logic)
                    symbolFaceCount = #nickname
                end
                
                local emptyFaceCount = 6 - symbolFaceCount
                local emptyFaceProbability = emptyFaceCount / 6
                
                -- Multiply by total probability
                totalProbability = totalProbability * emptyFaceProbability
            end
        else
            -- Object no longer exists, remove it from tracking
            diceInTray[guid] = nil
        end
    end
    
    -- Format probability as percentage
    local percentProbability = math.floor(totalProbability * 100 + 0.5)
    local displayText = "Bust Probability: " .. percentProbability .. "%"
    local textColor = "#FFFFFF" -- Default white
    
    -- Set color based on probability
    if percentProbability <= 20 then
        textColor = "#00FF00" -- Green for low probability (20% or less) - good for player
    elseif percentProbability >= 80 then
        textColor = "#FF0000" -- Red for high probability (80% or more) - bad for player
    end
    
    -- If no dice found, show default message
    if #dice == 0 then
        displayText = "Bust Probability: N/A"
    end
    
    -- Update UI text element and color
    tray.UI.setValue("probabilityText", displayText)
    tray.UI.setAttributes("probabilityText", {color = textColor})
    
    -- Log for debugging
    DiceTrayLib.log("Updated probability display: " .. displayText .. " (Color: " .. textColor .. ")", loggingEnabled)
    
    return diceInTray
end

-- Start monitoring dice to detect when they've stopped rolling
function DiceTrayLib.startDiceMonitoring(tray, dice, diceInTray, loggingEnabled)
    -- Variables to track monitoring state
    local elapsedTime = 0
    local monitoringId = nil
    
    -- Function to check if all dice have stopped rolling
    local function checkDiceStatus()
        -- Update elapsed time
        elapsedTime = elapsedTime + DiceTrayLib.CHECK_INTERVAL
        
        -- Check if we've exceeded the maximum wait time
        if elapsedTime >= DiceTrayLib.MAX_WAIT_TIME then
            DiceTrayLib.log("Maximum wait time reached, proceeding with dice sorting", loggingEnabled)
            -- Stop the monitoring
            if monitoringId then
                Wait.stop(monitoringId)
            end
            -- Process the dice results
            DiceTrayLib.checkDiceResults(tray, dice, diceInTray, loggingEnabled)
            return
        end
        
        -- Check if all dice are resting
        local allResting = true
        for _, die in ipairs(dice) do
            -- Make sure the die still exists
            if die ~= nil and die.getGUID ~= nil then
                -- Check if the die is resting (not moving)
                if not die.resting then
                    allResting = false
                    break
                end
            end
        end
        
        -- If all dice are resting, proceed with sorting
        if allResting then
            DiceTrayLib.log("All dice have stopped rolling after " .. elapsedTime .. " seconds", loggingEnabled)
            -- Stop the monitoring
            if monitoringId then
                Wait.stop(monitoringId)
            end
            -- Process the dice results
            DiceTrayLib.checkDiceResults(tray, dice, diceInTray, loggingEnabled)
        end
    end
    
    -- Start the monitoring loop
    DiceTrayLib.log("Starting dice roll monitoring", loggingEnabled)
    monitoringId = Wait.time(checkDiceStatus, DiceTrayLib.CHECK_INTERVAL, -1) -- -1 means repeat indefinitely
end

return DiceTrayLib
