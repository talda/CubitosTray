--[[
Ready/Available tokens and control panel by Maginomicon
Credit to Tobii for the original drafting tools set.

Use this panel with these tokens to manage readiness to move on.

All players should put a token near their play area, where everyone can see it. 
(Delete extra tokens if you're using an AUTO-RESET mode.)

When the panel is in the game, and set to one of the AUTO-RESET modes, it will automatically flip over the player tokens to that mode's side when all of these tokens show the OTHER side.

"Auto Reset to NO" mode is useful in games (such as Flamme Rouge) where you want everyone to be able to mark that they're ready to move on.

"Auto Reset to YES" mode is useful in games (such as Cockroach Poker) where you want to indicate that a player is still an option.
]]--

numTokens = 0
tokenGUIDs = {}
mode = 0
btn_list = {}

btn_w_ENABLED = 450
btn_h_ENABLED = 80
btn_wh_DISABLED = 0
token_property = "maginomicon_isReadyToken"

function onload()
    local button_parameters = {}
    
    btn_list["SetYes"] = 0
    button_parameters.click_function = "onClick_SetYes"
    button_parameters.function_owner = self
    button_parameters.label = "Set all to YES"
    button_parameters.position = {0.0, 0.5, -0.2}
    button_parameters.width = btn_w_ENABLED
    button_parameters.height = btn_h_ENABLED
    button_parameters.font_size = 60
    button_parameters.color = Color.Green
    
    self.createButton(button_parameters)
    
    btn_list["SetNo"] = 1
    button_parameters.click_function = "onClick_SetNo"
    button_parameters.function_owner = self
    button_parameters.label = "Set all to NO"
    button_parameters.position = {0.0, 0.5, 0.2}
    button_parameters.width = btn_w_ENABLED
    button_parameters.height = btn_h_ENABLED
    button_parameters.font_size = 60
    button_parameters.color = Color.Red
    
    self.createButton(button_parameters)
    
    btn_list["ToggleReset"] = 2
    button_parameters.click_function = "onClick_ToggleReset"
    button_parameters.function_owner = self
    button_parameters.label = "Auto-Reset: OFF"
    button_parameters.position = {0.0, -0.5, 0.0}
    button_parameters.rotation = {180.0, 180.0, 0.0}
    button_parameters.width = btn_w_ENABLED
    button_parameters.height = btn_h_ENABLED
    button_parameters.font_size = 40
    button_parameters.color = Color.White
    
    self.createButton(button_parameters)
    
    btn_list["texttop"] = 3
    button_parameters.click_function = "doNothing"
    button_parameters.function_owner = self
    button_parameters.label = "FLIP FOR SETTINGS\n\n\n\n\n\n\n\n\n\n\nFLIP FOR SETTINGS"
    button_parameters.position = {0.0, 0.5, 0.0}
    button_parameters.rotation = {0.0, 0.0, 0.0}
    button_parameters.width = btn_wh_DISABLED
    button_parameters.height = btn_wh_DISABLED
    button_parameters.font_size = 40
    button_parameters.color = Color.Black
    
    self.createButton(button_parameters)
    
    btn_list["texttop"] = 4
    button_parameters.click_function = "doNothing"
    button_parameters.function_owner = self
    button_parameters.label = "FLIP FOR SET BUTTONS\n\n\n\n\n\n\n\n\n\n\nFLIP FOR SET BUTTONS"
    button_parameters.position = {0.0, -0.5, 0.0}
    button_parameters.rotation = {180.0, 180.0, 0.0}
    button_parameters.width = btn_wh_DISABLED
    button_parameters.height = btn_wh_DISABLED
    button_parameters.font_size = 40
    button_parameters.color = Color.Black
    
    self.createButton(button_parameters)
end

function doNothing()
end

function onClick_SetYes()
    for i,obj in ipairs(getAllObjects()) do
        if obj.getVar(token_property) then 
            cur = obj.getRotation()
            obj.setRotation({cur.x,cur.y,0})
        end
    end
end

function onClick_SetNo()
    for i,obj in ipairs(getAllObjects()) do
        if obj.getVar(token_property) then 
            cur = obj.getRotation()
            obj.setRotation({cur.x,cur.y,180})
        end
    end
end

function onClick_ToggleReset()
    --log("!! onClick_ToggleReset, numTokens = " .. numTokens .. ", mode = " .. mode)
    num = 0
    if numTokens == 0 then
        checkBuild()
    end
    if mode == 0 then
        -- set mode to 1 (flip all to NO when all are YES)
        mode = 1
        modifyButton(btn_list["ToggleReset"],"Auto-Reset: to NO",Color.Red,true)
        modifyButton(btn_list["SetYes"],"",Color.Green,false)
        modifyButton(btn_list["SetNo"],"Set all to NO",Color.Red,true)
    elseif mode == 1 then
        -- set mode to -1 (flip all to YES when all are NO)
        mode = -1
        modifyButton(btn_list["ToggleReset"],"Auto-Reset: to YES",Color.Green,true)
        modifyButton(btn_list["SetYes"],"Set all to YES",Color.Green,true)
        modifyButton(btn_list["SetNo"],"",Color.Red,false)
    elseif mode == -1 then
        -- set mode to 0 (do not automatically flip anything)
        mode = 0
        modifyButton(btn_list["ToggleReset"],"Auto-Reset: OFF",Color.White,true)
        modifyButton(btn_list["SetYes"],"Set all to YES",Color.Green,true)
        modifyButton(btn_list["SetNo"],"Set all to NO",Color.Red,true)
    end
end

--[[ modifyButton(btn_num[, enabled OR [text , color[, enabled] ] ])
This function changes a button's details
With 1 argument, it merely switches the button between enabled and disabled
With 2 arguments, it manually sets whether the button is enabled or disabled
With 3 or 4 arguments, it modifies the text (2nd argument) and color (3rd argument) of the button
With 4 arguments, it also manually sets whether the button is enabled or disabled
Arguments (in order):
number: the number of the button
string: the text to be put on the button
table: A color to be put on the button
boolean: Whether to specifically enable or disable the button regardless of its current status
]]--

function getNumTokens()
    --log("!! getNumTokens()")
    num = 0
    for i,obj in ipairs(getAllObjects()) do
        if obj.getVar(token_property) then
            num = num + 1
        end
    end
    return num
end

function checkBuild()
    --log("-- checkBuild()")
    test = getNumTokens()
    if numTokens ~= test then buildTokens() end
end

function buildTokens()
    --log("-- -- buildTokens()")
    numTokens = 0
    tokenGUIDs = {}
    for i,obj in ipairs(getAllObjects()) do
        if obj.getVar(token_property) then 
            -- populate the tokenGUIDs list
            -- log( "This GUID = " .. obj.getGUID() )
            table.insert( tokenGUIDs,obj.getGUID() )
            numTokens = numTokens + 1
        end
    end
end

function onUpdate()
    if mode ~= 0 and numTokens > 0 then
    --log("==== Update: mode = " .. mode .. ", numTokens = " .. numTokens )
        checkBuild()
        facing = 0
        for i,v in pairs(tokenGUIDs) do
            -- log("GUID = " .. v )
            if getObjectFromGUID(v).is_face_down then
                facing = facing - 1 -- a token is face-down
            else
                facing = facing + 1 -- a token is face-up
            end
        end
        if facing == numTokens and mode == 1 then
            onClick_SetNo()
            broadcastToAll("Everyone's marked YES/READY, so move on.", Color.Red)
        end
        if -facing == numTokens and mode == -1 then
            onClick_SetYes()
            broadcastToAll("Everyone's marked NO/UNAVAILABLE, so move on.", Color.Green)
        end
    end
end

function yell(msg)
	rgb = {r=1, g=0, b=0}
	broadcastToAll(msg, rgb)
end

--[[ modifyButton(btn_num[, enabled OR [text , color[, enabled] ] ])
This function changes a button's details
With 1 argument, it merely switches the button between enabled and disabled
With 2 arguments, it manually sets whether the button is enabled or disabled
With 3 or 4 arguments, it modifies the text (2nd argument) and color (3rd argument) of the button
With 4 arguments, it also manually sets whether the button is enabled or disabled
Arguments (in order):
number: the number of the button
string: the text to be put on the button
table: A color to be put on the button
boolean: Whether to specifically enable or disable the button regardless of its current status
]]--
function modifyButton(...)
	--log(">>>> modifyButton")
	--log(">>--<< modifyButton " .. select(1,...))
	--log("select('#',...) =".. select('#',...) )
	if ( select('#',...) < 1 or select('#',...) > 4 ) then return 1 end
	
	--log("type 1 = ".. type(select(1,...)) .. "\ntype 2 = " .. type(select(2,...)) .. "\ntype 3 = ".. type(select(3,...)) .. "\ntype 4 = ".. type(select(4,...)) )
	
	if (
		type(select(1,...)) ~= "number" or 
		( select('#',...) == 2 and type(select(2,...)) ~= "boolean" ) or 
		( select('#',...) >= 3 and type(select(2,...)) ~= "string" ) or 
		( select('#',...) >= 3 and type(select(3,...)) ~= "table" ) or 
		( select('#',...) == 4 and type(select(4,...)) ~= "boolean" )
		)
		then return 2
	end
	
	-- load the arguments into local variables
	local btn_num = select(1,...)
	local btn_text = select(2,...)
	local btn_color = select(3,...)
	local enabled
	if select('#',...) == 2
		then
			enabled = select(2,...)
		else
			enabled = select(4,...)
	end
	--log(enabled,"-- enabled = ")
	
	-- if there's only one argument
	if select('#',...) == 1
		then
			--log(">>>>-- there was 1 argument")
			--log(self.getButtons()[btn_num+1]["width"],"self.getButtons()[btn_num+1]['width'] =")
			-- if the button is currently disabled
			if ( self.getButtons()[btn_num+1]["width"] == btn_wh_DISABLED )
				then
					-- enable button
					--log(">>>>-- Enable button ".. btn_num)
					self.editButton({ index=btn_num, width=btn_w_ENABLED, height=btn_h_ENABLED })
					-- NOTE: The +1 here is because of the differences in indexing between Lua and C++/Unity
					--log(self.getButtons()[btn_num+1]["width"],"self.getButtons()[btn_num+1]['width'] =")
				else
					-- disable button
					--log(">>>>-- Disable button ".. btn_num)
					self.editButton({ index=btn_num, width=btn_wh_DISABLED, height=btn_wh_DISABLED })
					-- NOTE: The +1 here is because of the differences in indexing between Lua and C++/Unity
					--log(self.getButtons()[btn_num+1]["width"],"self.getButtons()[btn_num+1]['width'] =")
			end
			--log("<<<< modifyButton")
			return 0
	end
	
	-- if there's exactly 2 arguments
	if select('#',...) == 2
		then
			--log(">>>>-- there were 2 arguments")
			local size_w = btn_wh_DISABLED
            local size_h = btn_wh_DISABLED
			-- enable or disable the button
			if enabled then
                size_w = btn_w_ENABLED
                size_h = btn_h_ENABLED
            end
			self.editButton({ index=btn_num, width=size_w, height=size_h })
			--log("<<<< modifyButton")
			return 0
	end
	
	-- if there's exactly 3 arguments
	if select('#',...) == 3
		then
			--log(">>>>-- there were 3 arguments")
			-- modify button
			--log(">>>>-- Modifying button ".. btn_num)
			self.editButton({ index=btn_num, label=btn_text, color=btn_color })
			--log("<<<< modifyButton")
			return 0
	end
	
	-- if there's exactly 4 arguments
	if select('#',...) == 4
		then
			--log(">>>>-- there were 4 arguments")
			-- modify button
			--log(">>>>-- Modifying button ".. btn_num)
			local size_w = btn_wh_DISABLED
            local size_h = btn_wh_DISABLED
			-- enable or disable the button
			if enabled then
                size_w = btn_w_ENABLED
                size_h = btn_h_ENABLED
            end
			self.editButton({ index=btn_num, label=btn_text, color=btn_color, width=size_w, height=size_h })
			--log("<<<< modifyButton")
			return 0
	end
	
	--log("<<<< modifyButton")
	return 4
end