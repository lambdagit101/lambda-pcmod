AddCSLuaFile()

if SERVER then
    util.AddNetworkString('pc_openlinux')
    util.AddNetworkString('pc_installos')
    util.AddNetworkString('pc_openwindows')
    util.AddNetworkString('pc_receiveos')
    util.AddNetworkString('pc_installerclosed')
end

if CLIENT then
    local MarginsX = 40
    local MarginsY = 40

    include("lbpc/appinit.lua")

    net.Receive("pc_installos", function(len)
        local installer = vgui.Create("DFrame")
        installer:SetSize(300, 150)
        installer:SetTitle("OS Installer")
        installer:Center()
        installer:SetIcon("icon16/package.png")
        installer:SetBackgroundBlur(true)
        installer:MakePopup()
        installer.OnClose = function()
            net.Start("pc_installerclosed")
            net.SendToServer()
        end
        installer.Think = function(self)
            if LocalPlayer():Alive() ~= true then
                self:Close()
            end
        end
                
        local label = vgui.Create("DLabel", installer)
        label:Dock(TOP)
        label:SetText("Welcome to the OS installer!\nPlease choose an OS, and it will be installed for you.\nNote: It might take a few seconds to install any OS")
        label:SetContentAlignment(7)
        label:SizeToContents()
            
        local function AddOS(Name, ID, Time)
            local OS = vgui.Create("DButton", installer)
            OS:Dock(TOP)
            OS:DockMargin(0, 4, 0, 0)
            OS:SetText("Install " .. Name)
            OS.DoClick = function()
                installer:Remove()
                TextFrame = vgui.Create("DFrame")
                TextFrame:SetSize(250, 150)
                TextFrame:Center()
                TextFrame:ShowCloseButton(false)
                TextFrame:SetTitle("Installing " .. Name .. "...")
                TextFrame:MakePopup()
                local richtext = vgui.Create("RichText", TextFrame)
                richtext:Dock(FILL)
                richtext:SetText(Name .. " is now installing.\n\nThis process will take around " .. Time .. " seconds.")
                timer.Simple(Time, function()
                    TextFrame:SetTitle("Success!")
                    richtext:SetText(Name .. " is successfully installed!")
                    local cock = vgui.Create("DButton", TextFrame)
                    cock:Dock(BOTTOM)
                    cock:SetText("Exit")
                    cock.DoClick = function()
                        TextFrame:Close()
                        net.Start("pc_receiveos")
                        net.WriteString(ID)
                        net.SendToServer()
                    end
                end)
            end
        end       
            
        AddOS("Linux", "linux", math.random(6, 16))
        AddOS("Neon", "windows", math.random(14, 24))
    end)
        
    --[[ Linux ]]

    net.Receive("pc_openlinux", function(len)
                
        local IsLauncherOpen = false
                
        --[[ Warning Function ]]
        
        function Warning(Title, Message, YesFunc, NoFunc)
            Derma_Query(Message, Title, "Yes", YesFunc, "No", NoFunc)
        end
        
        
        --[[ Monitor ]]        
            
        surface.PlaySound("lambda/startup.mp3")
        
        local Monitor = vgui.Create("DFrame")
        Monitor:SetPos(MarginsX, MarginsY)
        Monitor:SetSize(ScrW() - MarginsX * 2, ScrH() - MarginsY * 2)
        Monitor:SetTitle("Computer")
        Monitor:SetIcon("icon16/tux.png")
        Monitor:SetBackgroundBlur(true)
        Monitor:ShowCloseButton(false)
        Monitor:SetDraggable(false)
        Monitor:MakePopup() 
        Monitor.OnClose = function()
            hook.Remove("Think", "pc_updatetime")
            IsLauncherOpen = false
        end       
        Monitor.Think = function(self)
            if LocalPlayer():Alive() ~= true then
                self:Close()
            end
        end
               
        local Wallpaper = vgui.Create("DImage", Monitor)
        Wallpaper:Dock(FILL)
        Wallpaper:SetImage("lambda/linuxwp.png", "noclamp smooth")
        Wallpaper:SetKeepAspect(false)
        Wallpaper:SetMouseInputEnabled(true)
        Wallpaper:SetKeyboardInputEnabled(true)
            
        local Desktop = vgui.Create("DPanel", Wallpaper)
        Desktop:Dock(FILL)
        Desktop:SetBackgroundColor(Color(0, 0, 0, 0))
            
        --[[ Statusbar ]]
            
        local Statusbar = vgui.Create("DPanel", Desktop)
        Statusbar:Dock(TOP)
        Statusbar:SetBackgroundColor(Color(0, 0, 0))
            
        local Time = vgui.Create("DLabel", Statusbar)
        Time:Dock(FILL)
        Time:SetTextColor(Color(255, 255, 255))
        Time:SetFont("ChatFont")
        Time:SetContentAlignment(5)
        Time:SetText(os.date("%a %H:%M", os.time()))
        hook.Add("Think", "pc_updatetime", function()
            Time:SetText(os.date("%a %H:%M", os.time()))
        end)
            
        local Activities = vgui.Create("DButton", Statusbar)
        Activities.Paint = function() end
        Activities:SetText(" Activities")
        Activities:Dock(LEFT)   
        Activities:SetFont("ChatFont")
        Activities:SetTextColor(Color(255, 255, 255))
        Activities:SetContentAlignment(4)
        Activities:SizeToContents()
        Activities.DoClick = function()
            --Do not open the launcher if it is already open
            if IsLauncherOpen then return end
            --Now it will know it's open
            IsLauncherOpen = true
            local ApplicationLauncher = vgui.Create("DFrame", Desktop)
            ApplicationLauncher:SetSize(300, 300)
            ApplicationLauncher:Center()
            ApplicationLauncher:SetTitle("Application Launcher")
            ApplicationLauncher.OnClose = function()
                IsLauncherOpen = false
            end
            ApplicationLauncher.OnRemove = function()
                IsLauncherOpen = false
            end
            
            local Scroll = vgui.Create("DScrollPanel", ApplicationLauncher)
            Scroll:Dock(FILL)

            local List = vgui.Create("DIconLayout", Scroll)
            List:Dock(FILL)
            List:SetSpaceY(5)
            List:SetSpaceX(5)
            
            --Function that adds apps
            local function AddIcon(name, icon, func, ...)
                local args = {...}
                local ListItem = List:Add("DButton")
                ListItem.Paint = function() end
                ListItem:SetText("")
                ListItem:SetSize(32, 32)
                ListItem:SetTooltip(name)
                local AppIcon = vgui.Create("DImage", ListItem)
                AppIcon:SetPos(4, 4)
                AppIcon:SetSize(20, 20)
                AppIcon:SetImage(icon)
                ListItem.DoClick = function(self)
                    func(unpack(args))
                end
            end
            
            local CrossLabel = List:Add("DLabel")
            CrossLabel.OwnLine = true
            CrossLabel:SetText("Cross-platform Applications")
            CrossLabel:SetSize(200, 15)
            
            for k, v in pairs(PCMOD_APPS) do
                AddIcon(PCMOD_APPS[k]["meta"]["name"], PCMOD_APPS[k]["meta"]["icon"], PCMOD_APPS[k]["run"], ApplicationLauncher, Desktop, Wallpaper)
            end
            
            local LinuxLabel = List:Add("DLabel")
            LinuxLabel.OwnLine = true
            LinuxLabel:SetText("Linux Applications")
            LinuxLabel:SetSize(200, 15)
            
            for k, v in pairs(PCMOD_APPS_LINUX) do
                AddIcon(PCMOD_APPS_LINUX[k]["meta"]["name"], PCMOD_APPS_LINUX[k]["meta"]["icon"], PCMOD_APPS_LINUX[k]["run"], ApplicationLauncher, Desktop, Wallpaper)
            end
            
            AddIcon("About", "icon16/book.png", function()
                local Window = vgui.Create("DFrame", Desktop)
                Window:SetSize(300, 100)
                Window:Center()
                Window:SetTitle("About")
                Window:SetIcon("icon16/book.png")
                Window:SetSizable(true)
                
                local OptionsCatList = vgui.Create("DCategoryList", Window)
                OptionsCatList:Dock(FILL)
                local About = OptionsCatList:Add("About")
                local Author = About:Add("Made with love by lambdaguy101")
                Author.DoClick = function()
                    gui.OpenURL("https://steamcommunity.com/profiles/76561198448486497/")
                end
                local Server = About:Add("Made initially for Lambda's DarkRP")
                Server.DoClick = function()
                    gui.OpenURL("https://web.lambdaguy101.com/")
                end
                local Style = About:Add("In the style of GNOME Desktop")
                Style.DoClick = function()
                    gui.OpenURL("https://www.gnome.org/")
                end
                About:Add("Wallpaper - Adwaita (Day) by Jakub Steiner")
                
                OptionsCatList:InvalidateLayout(true)
            end)
        end
            
        local Logoff = vgui.Create("DButton", Statusbar)
        Logoff.Paint = function() end
        Logoff:SetText("Log off ")
        Logoff:Dock(RIGHT)   
        Logoff:SetFont("ChatFont")
        Logoff:SetTextColor(Color(255, 255, 255))
        Logoff:SetContentAlignment(6)
        Logoff:SizeToContents()
        Logoff.DoClick = function()
            Monitor:Close()
        end
            
    end)
        
    --[[ Neon ]]

    net.Receive("pc_openwindows", function(len)
                
        local IsLauncherOpen = false
        local StartMenu
                
        --[[ Warning Function ]]
        
        function Warning(Title, Message, YesFunc, NoFunc)
            Derma_Query(Message, Title, "Yes", YesFunc, "No", NoFunc)
        end
        
        
        --[[ Monitor ]]        
        
        local Monitor = vgui.Create("DFrame")
        Monitor:SetPos(MarginsX, MarginsY)
        Monitor:SetSize(ScrW() - MarginsX * 2, ScrH() - MarginsY * 2)
        Monitor:SetTitle("Computer")
        Monitor:SetIcon("icon16/computer.png")
        Monitor:SetBackgroundBlur(true)
        Monitor:ShowCloseButton(false)
        Monitor:SetDraggable(false)
        Monitor:MakePopup() 
        Monitor.OnClose = function()
            hook.Remove("Think", "pc_updatetime")
            IsLauncherOpen = false
        end       
        Monitor.Think = function(self)
            if LocalPlayer():Alive() ~= true then
                self:Close()
            end
        end
            
        local Wallpaper = vgui.Create("DImage", Monitor)
        Wallpaper:Dock(FILL)
        Wallpaper:SetImage("lambda/windowswp.png", "noclamp smooth")
        Wallpaper:SetKeepAspect(false)
        Wallpaper:SetMouseInputEnabled(true)
        Wallpaper:SetKeyboardInputEnabled(true)
            
        local Desktop = vgui.Create("DPanel", Wallpaper)
        Desktop:Dock(FILL)
        Desktop:SetBackgroundColor(Color(0, 0, 0, 0))
            
            
        --[[ Taskbar ]]
            
        local Taskbar = vgui.Create("DPanel", Desktop)
        Taskbar:Dock(BOTTOM)
        Taskbar:SetSize(0, 50)
        Taskbar:SetBackgroundColor(Color(0, 0, 0, 235))
            
        local Time = vgui.Create("DLabel", Taskbar)
        Time:Dock(RIGHT)
        Time:SetTextColor(Color(255, 255, 255))
        Time:SetFont("ChatFont")
        Time:SetText(os.date("%I:%M %p\n%d/%m/%Y ", os.time()))
        Time:SetContentAlignment(6)
        Time:SizeToContents()
        hook.Add("Think", "pc_updatetime", function()
            Time:SetText(os.date("%I:%M %p \n%d/%m/%Y ", os.time()))
        end)
            
        local StartButton = vgui.Create("DButton", Taskbar)
        StartButton:SetText("Start")
        StartButton:Dock(LEFT)   
        StartButton:SetContentAlignment(5)
        StartButton:DockMargin(10, 10, 10, 10)
        StartButton:SetFont("ChatFont")
        StartButton.DoClick = function()
            --Do not open if it is already
            if IsLauncherOpen then 
               IsLauncherOpen = false
               StartMenu:Remove()
               return 
            end
            --Now it will know it's open
            IsLauncherOpen = true
            StartMenu = vgui.Create("DPanel", Desktop)
            StartMenu:SetSize(600, 400)
            StartMenu:SetPos(0, ScrH() - MarginsY * 2 - 484)
            StartMenu:SetBackgroundColor(Color(0, 0, 0, 235))
            StartMenu.OnRemove = function()
                IsLauncherOpen = false
            end
            
            local Scroll = vgui.Create("DScrollPanel", StartMenu)
            Scroll:Dock(FILL)

            local List = vgui.Create("DIconLayout", Scroll)
            List:SetSize(200, 0)
            List:Dock(LEFT)
            List:DockMargin(10, 10, 10, 10)
            List:SetSpaceY(5)
            List:SetSpaceX(5)
            
            --Function that adds apps
            local function AddIcon(name, icon, func, ...)
                local args = {...}
                local ListItem = List:Add("DButton")
                ListItem.Paint = function() end
                ListItem:SetText("")
                ListItem:SetSize(190, 32)
                ListItem:SetTooltip(name)
                local AppIcon = vgui.Create("DImage", ListItem)
                AppIcon:SetPos(4, 4)
                AppIcon:SetSize(20, 20)
                AppIcon:SetImage(icon)
                local AppName = vgui.Create("DLabel", ListItem)
                AppName:SetPos(26, 0)
                AppName:SetSize(106, 32)
                AppName:SetText(name)
                ListItem.DoClick = function(self)
                    func(unpack(args))
                end
            end
            
            local CrossLabel = List:Add("DLabel")
            CrossLabel.OwnLine = true
            CrossLabel:SetText("Cross-platform Applications")
            CrossLabel:SetSize(200, 15)
            
            for k, v in pairs(PCMOD_APPS) do
                AddIcon(PCMOD_APPS[k]["meta"]["name"], PCMOD_APPS[k]["meta"]["icon"], PCMOD_APPS[k]["run"], StartMenu, Desktop, Wallpaper)
            end
            
            local NeonLabel = List:Add("DLabel")
            NeonLabel.OwnLine = true
            NeonLabel:SetText("Neon Applications")
            NeonLabel:SetSize(200, 15)
            
            for k, v in pairs(PCMOD_APPS_WINDOWS) do
                AddIcon(PCMOD_APPS_WINDOWS[k]["meta"]["name"], PCMOD_APPS_WINDOWS[k]["meta"]["icon"], PCMOD_APPS_WINDOWS[k]["run"], StartMenu, Desktop, Wallpaper)
            end
            
            AddIcon("About", "icon16/book.png", function()
                local Window = vgui.Create("DFrame", Desktop)
                Window:SetSize(300, 100)
                Window:Center()
                Window:SetTitle("About")
                Window:SetIcon("icon16/book.png")
                Window:SetSizable(true)
                
                local OptionsCatList = vgui.Create("DCategoryList", Window)
                OptionsCatList:Dock(FILL)
                local About = OptionsCatList:Add("About")
                local Author = About:Add("Made with love by lambdaguy101")
                Author.DoClick = function()
                    gui.OpenURL("https://steamcommunity.com/profiles/76561198448486497/")
                end
                local Server = About:Add("Made initially for Lambda's DarkRP")
                Server.DoClick = function()
                    gui.OpenURL("https://web.lambdaguy101.com/")
                end
                local Style = About:Add("In the style of KDE Plasma")
                Style.DoClick = function()
                    gui.OpenURL("https://www.kde.org/")
                end
                About:Add("Wallpaper - Shell by Lucas Andrade")
                
                OptionsCatList:InvalidateLayout(true)
            end)
            
            local Logoff = vgui.Create("DButton", StartMenu)
            Logoff.Paint = function() end
            Logoff:SetText(" Shut Down")
            Logoff:Dock(BOTTOM)   
            Logoff:DockMargin(10, 10, 10, 10)
            Logoff:SetFont("ChatFont")
            Logoff:SetContentAlignment(4)
            Logoff:SetTextColor(Color(255, 255, 255))
            Logoff:SizeToContents()
            Logoff.DoClick = function()
                Monitor:Close()
            end
        end
    end)
end
