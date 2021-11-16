table.insert(PCMOD_APPS_WINDOWS, table.Count(PCMOD_APPS_WINDOWS), {
    ['meta'] = {
        ['name'] = "Notepad",
        ['icon'] = "icon16/page_edit.png"
    },
    ['run'] = function(StartMenu, Desktop)
        StartMenu:Remove()
            
        local Window = vgui.Create("DFrame", Desktop)
        Window:SetSize(520, 520)
        Window:Center()
        Window:SetTitle("Notepad")
        Window:SetIcon("icon16/page_edit.png")
        Window:SetSizable(true)
                                    
        local ActualNotepad = vgui.Create("DTextEntry", Window)
        ActualNotepad:Dock(FILL)
        ActualNotepad:SetMultiline(true)
        if file.Exists("lambda_pcmod_notepad.txt", "DATA") then
            ActualNotepad:SetValue(file.Read("lambda_pcmod_notepad.txt", "DATA"))
        end
                                                  
        local MenuBar = vgui.Create("DMenuBar", Window)
        MenuBar:Dock(TOP)

        local M1 = MenuBar:AddMenu("File")
        M1:AddOption("New", function() 
            Warning("New File Warning", "Do you want to make a new file?\nAll unsaved changes will be lost.", function() 
                ActualNotepad:SetValue("")
            end, function() end)
        end):SetIcon("icon16/page_add.png")
        M1:AddOption("Save", function() 
            Derma_StringRequest("Save file as", nil, "lambda_pcmod_notepad.txt", function(text) 
                file.Write(text, ActualNotepad:GetValue())
                Derma_Message("Your file has been saved.", "Saved successfully", "OK")
            end, nil, "Save", "Cancel")
        end):SetIcon("icon16/page_save.png")
        M1:AddOption("Load", function() 
            Derma_StringRequest("Load file", nil, "lambda_pcmod_notepad.txt", function(text) 
                ActualNotepad:SetValue(file.Read(text, "DATA"))
            end, nil, "Load", "Cancel")
        end):SetIcon("icon16/page_go.png")
                                                  
        local M3 = MenuBar:AddMenu("Help")
        M3:AddOption("About", function() 
            Derma_Message("This version of notepad is licensed to\n" .. LocalPlayer():GetName() .. "\n\nMade by lambdaguy101", "About Notepad", "OK")
        end)
    end
})

