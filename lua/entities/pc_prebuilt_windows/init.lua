AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.MaxDHealth = 200
ENT.DeviceHealth = 200

ENT.InstalledOS = true
ENT.OS = "windows"

function ENT:Initialize()
    self:SetModel("models/props/cs_office/computer_caseB.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if ( !IsValid( phys ) ) then return end
    phys:Wake()
end

function ENT:Use(ply)
    local nearObjects = ents.FindInSphere(self:GetPos(), 400)
    local isthereanactualmonitor = false
    for k, v in pairs(nearObjects) do
        if IsValid(v) and v:GetClass() == "pc_monitor" then
            ply:ChatPrint("PC is all good, maybe try the monitor?")
            isthereanactualmonitor = true
            return
        end
    end
    if isthereanactualmonitor == false then
        ply:ChatPrint("Your PC is ready! Get a monitor.")
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
