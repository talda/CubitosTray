function onload(saved_data)
    --Loads the tracking for if the game has started yet
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        valueData = loaded_data[1]
    else
        valueData = ""
    end


    self.createInput({
        input_function = "onInput",
        function_owner = self,
        label          = "Write here",
        alignment      = 3,
        position       = {0,0.4,0},
        rotation       = {0,90,0},
        width          = 1300,
        height         = 860,
        value          = valueData,
    })
end

function onInput(self, ply, text, selected)
    if not selected then
        valueData = text
        updateSave()
    end
end

function updateSave()
    saved_data = JSON.encode({valueData})
    self.script_state = saved_data
end
