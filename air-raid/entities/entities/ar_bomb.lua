AddCSLuaFile()

ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Air Raid Bomb"
ENT.Author          = "Almighty Laxz"

ENT.Category        = "Air Raid"

ENT.Spawnable       = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_phx/ww2bomb.mdl")
	    self:PhysicsInit(SOLID_VPHYSICS)
	    self:SetMoveType(MOVETYPE_VPHYSICS)
	    //self:SetSolid(SOLID_VPHYSICS)
	
	    local phys = self:GetPhysicsObject()
	
	    if not phys:IsValid() then
	        self:SetModel("models/props_phx/ww2bomb.mdl")
	        self:PhysicsInit(SOLID_VPHYSICS)
	        phys = self:GetPhysicsObject()
	    end
	
	    phys:Wake()
	    self:SetTrigger(true)
	    timer.Simple(15, function() if IsValid(self) then self:Remove() end end)
	end
	
	function ENT:PhysicsCollide()
	    util.BlastDamage(self, self, self:GetPos(), 200, 200)
	    local effect = EffectData()
      	effect:SetStart(self:GetPos())
      	effect:SetOrigin(self:GetPos())
      	effect:SetScale(2)
      	effect:SetRadius(2)
      	effect:SetMagnitude(10)
      	effect:SetNormal(Vector(0,0,0))
      	effect:SetOrigin(self:GetPos())
      	util.Effect("Explosion", effect, true, true)
      	util.Effect("HelicopterMegaBomb", effect, true, true)
	    SafeRemoveEntityDelayed(self, 0.05)
	end
end
