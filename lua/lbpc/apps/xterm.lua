table.insert(PCMOD_APPS_LINUX, table.Count(PCMOD_APPS_LINUX), {
    ['meta'] = {
        ['name'] = "XTerm",
        ['icon'] = "icon16/application_xp_terminal.png"
    },
    ['run'] = function(ApplicationLauncher, Desktop)
        
        local timeSinceLastStokeAttempt = 0
                                                              
        ApplicationLauncher:Remove()
            
        local Window = vgui.Create("DFrame", Desktop)
        Window:SetSize(640, 480)
        Window:Center()
        Window:SetTitle("XTerm")
        Window:SetIcon("icon16/application_xp_terminal.png")
        Window:SetSizable(true)
            
        local TerminalBG = vgui.Create("DPanel", Window)
        TerminalBG:Dock(FILL)
        TerminalBG:SetBackgroundColor(Color(0, 0, 0))
            
        local Terminal = vgui.Create("RichText", TerminalBG)
        Terminal:Dock(FILL)
        Terminal:SetText("Linux " .. LocalPlayer():GetName() .. os.date(" (%Y-%m-%d) ", os.time()) .. jit.arch .. "\n\n$ ")
                                                              
        
        local Shellbox = vgui.Create("DTextEntry", Window)
        Shellbox:Dock(BOTTOM)
        Shellbox:SetPlaceholderText("Type 'help' for a list of commands")
        Shellbox:DockMargin(0, 5, 0, 0)
        Shellbox.OnChange = function()
            if CurTime() - timeSinceLastStokeAttempt > 0.02 then 
                LocalPlayer():EmitSound("lambda/keystroke" .. math.random(1, 3) .. ".mp3")
            end
            timeSinceLastStokeAttempt = CurTime()
        end
                
        function handleCommand(cmd, args)
            --if IsValid(PCMOD_COMMANDS_LINUX[cmd]["execute"]) then
                PCMOD_COMMANDS_LINUX[cmd]["execute"](args, Shellbox, Terminal, TerminalBG)
            --else
                --Shellbox:SetText("")
                --Terminal:AppendText("sh: " .. cmd .. ": command not found\n$ ")
            --end
        end
                                                            
        Shellbox.OnEnter = function()
            Terminal:AppendText(Shellbox:GetValue() .. "\n")
            local command = string.Split(Shellbox:GetText(), " ")
            Shellbox:RequestFocus()
            handleCommand(command[1], string.Split(table.concat(command, " ", 2, #command), " "))
        end
    end
})

