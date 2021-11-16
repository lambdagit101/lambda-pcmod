if SERVER then
    util.AddNetworkString('soupchat_newmessage')
    util.AddNetworkString('soupchat_sendmessage')
    
    net.Receive('soupchat_sendmessage', function(len, ply)
        local receiver = net.ReadEntity()
        local message = net.ReadString()
        print("SoupChat: Message from " .. ply:Nick() .. " to " .. receiver:Nick() .. ": " .. message)
        net.Start('soupchat_newmessage')
        net.WriteEntity(ply)
        net.WriteString(message)
        net.Send(receiver)
    end)
end

table.insert(PCMOD_APPS, table.Count(PCMOD_APPS), {
    ['meta'] = {
        ['name'] = "SoupChat",
        ['icon'] = "icon16/comments.png"
    },
    ['run'] = function(AppLauncher, Desktop)
        AppLauncher:Remove()
                                   
        local Messages
        local ChattingPlayer
                        
        local SoupChat = vgui.Create("DFrame", Desktop)
        SoupChat:SetSize(300, 700)
        SoupChat:Center()
        SoupChat:SetTitle("SoupChat")
        SoupChat:SetIcon("icon16/comments.png")
        SoupChat:SetSizable(true)
                                                  
        local Tab = vgui.Create("DFrame", Desktop)
        Tab:SetSize(500, 500)
        Tab:SetTitle('No player selected')
        Tab:Center()
        Tab:SetIcon('icon16/comment.png')
        Tab:SetSizable(true)
        local Messages = vgui.Create("RichText", Tab)
        Messages:Dock(FILL)
        Messages:SetText("Select a player from the Players window")
        local Chatbox = vgui.Create("DTextEntry", Tab)
        Chatbox:Dock(BOTTOM)
        Chatbox:DockMargin(0, 4, 0, 0)
        Chatbox:SetPlaceholderText("Press ENTER to send a message")
        Chatbox.OnEnter = function(self)
            if not IsValid(ChattingPlayer) then return end
            if value == "" or value == "\n" then return end
            Messages:AppendText("\n (You) " .. LocalPlayer():GetName() .. ": " .. self:GetText())
            file.Append("soupchat_history_" .. ChattingPlayer:SteamID64() .. ".txt", "\n (You) " .. LocalPlayer():Nick() .. ": " .. self:GetText())
            self:RequestFocus()
            net.Start('soupchat_sendmessage')
            net.WriteEntity(ChattingPlayer)
            net.WriteString(self:GetText())
            net.SendToServer()
            self:SetText("")
        end
        SoupChat.OnClose = function()
            Tab:Remove()
        end
        Tab.OnClose = function()
            SoupChat:Remove()
            Messages = nil
            ChattingPlayer = nil
        end
        Tab.OnRemove = function()
            SoupChat:Remove()
            Messages = nil
            ChattingPlayer = nil
        end

        local List = vgui.Create("DScrollPanel", SoupChat)
        List:Dock(FILL)
        
        local Players = vgui.Create("DLabel", List)
        Players:Dock(TOP)
        Players:SetText("Players Online:")
        Players:DockMargin(4, 4, 4, 4)
        
        local function AddPerson(Player)
            local Person = vgui.Create("DButton", List)
            Person:SetText(Player:Nick() .. " ")
            Person:Dock(TOP)
            Person:SetFont("Default")
            Person:SetTextColor(Color(0, 0, 0))
            Person:SetContentAlignment(6)
            Person:SetSize(0, 32)
            Person:DockMargin(4, 0, 4, 4)
            Person.DoClick = function()
                ChattingPlayer = Player
                Tab:SetTitle('Chatting with ' .. Player:Nick())
                Messages:SetText('You are now chatting with ' .. Player:Nick() .. "\n")
                Messages:AppendText(file.Read("soupchat_history_" .. Player:SteamID64() .. ".txt") or "\n")
            end
            local Avatar = vgui.Create("AvatarImage", Person)
            Avatar:SetSize(32, 32)
            Avatar:Dock(LEFT)
            Avatar:SetPlayer(Player, 32)
        end
                                                  
        for k, v in pairs(player.GetAll()) do
            if v == LocalPlayer() then continue end
            AddPerson(v)
        end
                                                  
        net.Receive('soupchat_newmessage', function(len)
            local receivedfrom = net.ReadEntity()
            local Message = net.ReadString()
            if IsValid(Messages) then
                surface.PlaySound('friends/message.wav')
            end
            file.Append("soupchat_history_" .. receivedfrom:SteamID64() .. ".txt", "\n" .. receivedfrom:Nick() .. ": " .. Message)
            if receivedfrom == ChattingPlayer then
                if IsValid(Messages) then
                    file.Append("soupchat_history_" .. receivedfrom:SteamID64() .. ".txt", "\n" .. receivedfrom:Nick() .. ": " .. Message)
                    Messages:AppendText("\n" .. receivedfrom:Nick() .. ": " .. Message)
                end
            end
        end)
    end
})
