table.insert(PCMOD_APPS_LINUX, table.Count(PCMOD_APPS_LINUX), {
    ['meta'] = {
        ['name'] = "gedit",
        ['icon'] = "icon16/page_edit.png"
    },
    ['run'] = function(ApplicationLauncher, Desktop)
        ApplicationLauncher:Remove()
            
        local Window = vgui.Create("DFrame", Desktop)
        Window:SetSize(520, 520)
        Window:Center()
        Window:SetTitle("gedit")
        Window:SetIcon("icon16/page_edit.png")
        Window:SetSizable(true)
                                    
        local ActualNotepad = vgui.Create("DTextEntry", Window)
        ActualNotepad:Dock(FILL)
        ActualNotepad:SetMultiline(true)
        if file.Exists("lambda_pcmod_gedit.txt", "DATA") then
            ActualNotepad:SetValue(file.Read("lambda_pcmod_gedit.txt", "DATA"))
        end
                                                  
        local MenuBar = vgui.Create("DMenuBar", Window)
        MenuBar:Dock(TOP)

        local M1 = MenuBar:AddMenu("File")
        M1:AddOption("New", function() 
            Warning("New File Warning", "All unsaved changes will be lost,\nare you sure you want to continue?", function() 
                ActualNotepad:SetValue("")
            end, function() end)
        end):SetIcon("icon16/page_add.png")
        M1:AddOption("Save", function() 
            Derma_StringRequest("Save file as", nil, "lambda_pcmod_gedit.txt", function(text) 
                file.Write(text, ActualNotepad:GetValue())
                Derma_Message("Your file has been saved.\nYou can load it anytime by pressing \"Load File\", and writing the filename.", "Saved successfully", "OK")
            end, nil, "Save", "Cancel")
        end):SetIcon("icon16/page_save.png")
        M1:AddOption("Load", function() 
            Derma_StringRequest("Load file", nil, "lambda_pcmod_gedit.txt", function(text) 
                ActualNotepad:SetValue(file.Read(text, "DATA"))
            end, nil, "Load", "Cancel")
        end):SetIcon("icon16/page_go.png")
                                                  
        local M3 = MenuBar:AddMenu("Help")
        M3:AddOption("About", function() 
            Derma_Message("Made by lambdaguy101", "About gedit", "OK")
        end)
    end
})

