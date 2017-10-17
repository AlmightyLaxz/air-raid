if SERVER then
   AddCSLuaFile("shared.lua")
end

if CLIENT then
   SWEP.Slot         = 0
   SWEP.ViewModelFOV = 10
end

SWEP.HoldType = "normal"

SWEP.Base = "weapon_base"
SWEP.ViewModel  = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.AllowDelete = false
SWEP.AllowDrop = false

SWEP.NoSights = true

SWEP.PrintName             = "Empty"
SWEP.Category           = "Air Raid"
SWEP.Author             = "Almighty Laxz";
SWEP.Contact            = "";
SWEP.Purpose            = "Do nothing";
SWEP.Instructions          = "Do nothing";

function SWEP:PrimaryAttack()
	local ent = self.Owner:GetEyeTrace().Entity
	if ent:IsPlayer() and ent:GetPos():Distance(self.Owner:GetPos()) < 100 or ent:GetClass() == "func_physbox" and ent:GetPos():Distance(self.Owner:GetPos()) < 100 then
		local av = self.Owner:GetAimVector()
		ent:SetVelocity(Vector(av.x, av.y, 0.4) * 1000)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end

function SWEP:Initialize()
   self:SetHoldType(self.HoldType)
end

function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end