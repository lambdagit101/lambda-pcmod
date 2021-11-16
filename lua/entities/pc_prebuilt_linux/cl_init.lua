local MarginsX = 80
local MarginsY = 80

include("lbpc/appinit.lua")
include('shared.lua')

function ENT:Draw()
   self:DrawModel() 
end

local IsLauncherOpen = false

net.Receive("pc_openpc", function(len)
            
    --[[ Warning Function ]]
    
    function Warning(Title, Message, YesFunc, NoFunc)
        Derma_Query(Message, Title, "Yes", YesFunc, "No", NoFunc)
    end
    
    
    --[[ Monitor ]]        
    
    surface.PlaySound('lambda/startup.mp3')
           
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
           
    local Desktop = vgui.Create("DPanel", Monitor)
    Desktop:Dock(FILL)
           
           
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
           
        for k, v in pairs(PCMOD_APPS) do
            AddIcon(PCMOD_APPS[k]["meta"]["name"], PCMOD_APPS[k]["meta"]["icon"], PCMOD_APPS[k]["run"], ApplicationLauncher, Desktop)
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
            local Style = About:Add("In the style of GNOME Desktop")
            Style.DoClick = function()
                gui.OpenURL("https://www.gnome.org/")
            end
               
            OptionsCatList:InvalidateLayout(true)
        end)
    end
           
    local Logoff = vgui.Create("DButton", Statusbar)
    Logoff.Paint = function() end
    Logoff:SetText("Log out ")
    Logoff:Dock(RIGHT)   
    Logoff:SetFont("ChatFont")
    Logoff:SetTextColor(Color(255, 255, 255))
    Logoff:SetContentAlignment(6)
    Logoff:SizeToContents()
    Logoff.DoClick = function()
        Monitor:Close()
    end
           
           
    --[[ Dock ]]
           
    
           
end)
