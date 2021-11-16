AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.DeviceHealth = 125
ENT.MaxDHealth = 125
ENT.InstallingOS = false

function ENT:Initialize()
    self:SetModel("models/props_lab/monitor01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if ( !IsValid( phys ) ) then return end
    phys:Wake()
end

function ENT:Use(ply)
    if self:WaterLevel() > 1 then
        ply:ChatPrint("The monitor is submerged in water")
        return 
    end
    local nearObjects = ents.FindInSphere(self:GetPos(), 400)
    local components = {}
    local componentslength = 0
    local isthereanactualpc = false
    for k, v in pairs(nearObjects) do
        if IsValid(v) and v:GetClass() == "pc_case" or v:GetClass() == "pc_prebuilt_linux" or v:GetClass() == "pc_prebuilt_windows" then
            if v:WaterLevel() > 1 then
                ply:ChatPrint("The computer is submerged in water")
                return
            end
            if v:GetClass() == "pc_case" then
                for i, item in pairs(v.RequiredComponents) do
                    if item == true then
                        table.insert(components, scripted_ents.Get(i).PrintName)
                        componentslength = componentslength + 1
                    end
                end
                if componentslength != 0 then
                    ply:ChatPrint("Your PC is missing components: " .. table.concat(components, ", "))
                else
                    if v.InstalledOS == false and self.InstallingOS == false then
                        self.InstallingOS = true
                        net.Start("pc_installos")
                        net.Send(ply)
                        net.Receive("pc_installerclosed", function(len)
                            self.InstallingOS = false
                        end)
                        net.Receive("pc_receiveos", function(len, ply)
                            v.OS = net.ReadString()
                            v.InstalledOS = true
                            net.Start("pc_open" .. v.OS)
                            net.Send(ply)
                        end)
                    else
                        if v.InstalledOS == false then return end
                        net.Start("pc_open" .. v.OS)
                        net.Send(ply)
                        self:EmitSound('lambda/startup.mp3')
                    end
                end
            else
                net.Start("pc_open" .. v.OS)
                net.Send(ply)
                self:EmitSound('lambda/startup.mp3')
            end
            isthereanactualpc = true
            return
        end
    end
    if isthereanactualpc == false then
        ply:ChatPrint("No computer nearby.")
    end
end

function ENT:OnRemove()
    if self.DeviceHealth < 1 then
        local pos = self:GetPos()
        self:Remove() 
        self.m_bApplyingDamage = false
        local explo = ents.Create("env_explosion")
        explo:SetPos(pos)
        explo:Spawn()
        explo:Fire("Explode")
        explo:SetKeyValue("IMagnitude", 0)
    end
end

function ENT:OnTakeDamage(dmginfo)
    if not self.m_bApplyingDamage then
		self.m_bApplyingDamage = true
		self.DeviceHealth = self.DeviceHealth - dmginfo:GetDamage()
		self.m_bApplyingDamage = false
        if self.DeviceHealth < 1 then
           self:Remove()
           return
        end
	end
end

