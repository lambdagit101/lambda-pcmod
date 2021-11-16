AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.RequiredComponents = {
    ["pc_hdd"] = true,
    ["pc_ram"] = true,
    ["pc_os"] = true,
    ["pc_cpu"] = true,
    ["pc_gpu"] = true,
    ["pc_supply"] = true,
    ["pc_mboard"] = true,
    ["pc_dvd"] = true,
    ["pc_internet"] = true,
}
ENT.MaxDHealth = 200
ENT.DeviceHealth = 200

ENT.InstalledOS = false
ENT.OS = "linux"

function ENT:ValidComponent(ent)
   return self.RequiredComponents[ent:GetClass()] 
end

function ENT:PhysicsCollide(data, phys)
    if self:WaterLevel() > 1 then return end
    if self:ValidComponent(data.HitEntity) == true then
        data.HitEntity:Remove()
        self.RequiredComponents[data.HitEntity:GetClass()] = false
        self:EmitSound("weapons/stunstick/spark" .. math.random(1, 3) .. ".wav")
    end
end

function ENT:Initialize()
    self:SetModel("models/props_lab/harddrive02.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if ( !IsValid( phys ) ) then return end
    phys:Wake()
end

function ENT:Use(ply)
    local components = {}
    local componentslength = 0
    for i, item in pairs(self.RequiredComponents) do
        if item == true then
            table.insert(components, scripted_ents.Get(i).PrintName)
            componentslength = componentslength + 1
        end
    end
    if componentslength != 0 then
        ply:ChatPrint("Missing components: " .. table.concat(components, ", "))
    else
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
