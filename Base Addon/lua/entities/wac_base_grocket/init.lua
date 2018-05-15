
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local ExploSnds = {}
ExploSnds[1]                         =  "explosions/doi_ty_01.wav"
ExploSnds[2]                         =  "explosions/doi_ty_02.wav"
ExploSnds[3]                         =  "explosions/doi_ty_03.wav"
ExploSnds[4]                         =  "explosions/doi_ty_04.wav"

local CloseExploSnds = {}
CloseExploSnds[1]                         =  "explosions/doi_ty_01_close.wav"
CloseExploSnds[2]                         =  "explosions/doi_ty_02_close.wav"
CloseExploSnds[3]                         =  "explosions/doi_ty_03_close.wav"
CloseExploSnds[4]                         =  "explosions/doi_ty_04_close.wav"

local DistExploSnds = {}
DistExploSnds[1]                         =  "explosions/doi_ty_01_dist.wav"
DistExploSnds[2]                         =  "explosions/doi_ty_02_dist.wav"
DistExploSnds[3]                         =  "explosions/doi_ty_03_dist.wav"
DistExploSnds[4]                         =  "explosions/doi_ty_03_dist.wav"

local WaterExploSnds = {}
WaterExploSnds[1]                         =  "explosions/doi_ty_01_water.wav"
WaterExploSnds[2]                         =  "explosions/doi_ty_02_water.wav"
WaterExploSnds[3]                         =  "explosions/doi_ty_03_water.wav"
WaterExploSnds[4]                         =  "explosions/doi_ty_04_water.wav"

local CloseWaterExploSnds = {}
CloseWaterExploSnds[1]                         =  "explosions/doi_ty_01_closewater.wav"
CloseWaterExploSnds[2]                         =  "explosions/doi_ty_02_closewater.wav"
CloseWaterExploSnds[3]                         =  "explosions/doi_ty_03_closewater.wav"
CloseWaterExploSnds[4]                         =  "explosions/doi_ty_04_closewater.wav"

function ENT:Initialize()
	math.randomseed(CurTime())
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.phys = self.Entity:GetPhysicsObject()
	if (self.phys:IsValid()) then
		self.phys:SetMass(400)
		self.phys:EnableGravity(false)
		self.phys:EnableCollisions(true)
		self.phys:EnableDrag(false)
		self.phys:Wake()
	end
	self.sound = CreateSound(self.Entity, "")
	self.matType = MAT_DIRT
	self.hitAngle = Angle(270, 0, 0)
	self.ExplosionSound                  =  table.Random(CloseExploSnds)
	self.FarExplosionSound				 =  table.Random(ExploSnds)
	self.DistExplosionSound				 =  table.Random(DistExploSnds)
	self.WaterExplosionSound			 =  table.Random(CloseWaterExploSnds)
	self.WaterFarExplosionSound			 =  table.Random(WaterExploSnds)
end

function ENT:Explode(tr)
	if self.Exploded then return end
	self.Exploded = true
	pos = self:GetPos()
	util.BlastDamage(self,self.Owner or self,pos,self.Radius*1.5,self.Damage)
    if(self:WaterLevel() >= 1) then --Not working
		if tr2.Hit then
			ParticleEffect("ins_water_explosion", tr2.HitPos, Angle(-90,0,0), nil)
			self.ExplosionSound =  self.WaterExplosionSound
			self.FarExplosionSound = self.WaterFarExplosionSound 
		end
	end
	ParticleEffect("doi_mortar_explosion",pos,Angle(self.hitAngle, -90, 0),nil)
	local ent = ents.Create("shockwave_sound_lowsh")
	ent:SetPos( pos ) 
	ent:Spawn()
	ent:Activate()
	ent:SetVar("GBOWNER", ply)
	ent:SetVar("MAX_RANGE",self.Damage*(self.Radius*1.5))
	ent:SetVar("NOFARSOUND",0)
	ent:SetVar("SHOCKWAVE_INCREMENT",200)
	ent:SetVar("DELAY",0.01)
	ent:SetVar("SOUNDCLOSE", self.ExplosionSound)
	ent:SetVar("SOUND", self.FarExplosionSound)
	ent:SetVar("SOUNDFAR", self.DistExplosionSound)
	ent:SetVar("Shocktime", 0)
	self:Remove()

end

function ENT:StartRocket()
	if self.Started then return end	
	self.Owner = self.Owner or self.Entity
	self.Fuel=self.Fuel or 1000
	self.Started = true
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ParticleEffectAttach("ins_rockettrail",PATTACH_ABSORIGIN_FOLLOW,self.Entity,1)
	local light = ents.Create("env_sprite")
	light:SetPos(self.Entity:GetPos())
	light:SetKeyValue("renderfx", "0")
	light:SetKeyValue("rendermode", "5")
	light:SetKeyValue("renderamt", "255")
	light:SetKeyValue("rendercolor", "250 200 100")
	light:SetKeyValue("framerate12", "20")
	light:SetKeyValue("model", "light_glow03.spr")
	light:SetKeyValue("scale", "0.4")
	light:SetKeyValue("GlowProxySize", "50")
	light:Spawn()
	light:SetParent(self.Entity)
	self.sound:Play()
	self.OldPos=self:GetPos()
	self.phys:EnableCollisions(false)
end

function ENT:OnRemove()
	self.sound:Stop()
end

function ENT:GetFuelMul()
	self.MaxFuel=self.MaxFuel or self.Fuel or 0
	if self.Fuel then
		return math.Clamp(self.Fuel/self.MaxFuel*5,0,1)
	end
	return 1
end

function ENT:PhysicsUpdate(ph)
	if !self.Started or self.HasNoFuel then return end
	local trd = {
		start = self.OldPos,
		endpos = self:GetPos(),
		filter = {self,self.Owner,self.Launcher},
		mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER + CONTENTS_WINDOW
	}
	local tr = util.TraceLine(trd)
	
	local trd2 = {
		start   = tr.HitPos,
		endpos  = tr.endpos,
		filter  = {self,self.Owner,self.Launcher},
		mask    = MASK_WATER + CONTENTS_TRANSLUCENT
	}
	local tr2 = util.TraceLine(trd2)
	
	if tr.Hit and !self.Exploded then
		if tr.HitSky then self:Remove() return end
		util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		self.matType = tr.MatType
		self.hitAngle = tr.HitNormal:Angle()
		self:Explode()
		return
	end
	self.OldPos = trd.endpos
	local vel = self:WorldToLocal(self:GetPos()+self:GetVelocity())*0.4
	vel.x = 0
	local m = self:GetFuelMul()
	ph:AddVelocity(self:GetForward()*m*self.Speed-self:LocalToWorld(vel*Vector(0.1, 1, 1))+self:GetPos())
	ph:AddAngleVelocity(
		ph:GetAngleVelocity()*-0.4
		+ Vector(math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1))*5
		+ Vector(0, -vel.z, vel.y)
	)
	if self.calcTarget then
		local target = self:calcTarget()
		local dist = self:GetPos():Distance(target)
		if dist > 2000 then
			target = target + Vector(0,0,200)
		end
		local v = self:WorldToLocal(target + Vector(
			0, 0, math.Clamp((self:GetPos()*Vector(1,1,0)):Distance(target*Vector(1,1,0))/5 - 50, 0, 1000)
		)):GetNormal()
		v.y = math.Clamp(v.y*10,-0.5,0.5)*300
		v.z = math.Clamp(v.z*10,-0.5,0.5)*300
		self:TakeFuel(math.abs(v.y) + math.abs(v.z))
		ph:AddAngleVelocity(Vector(0,-v.z,v.y))
	end
	self:TakeFuel(self.Speed)
end

function ENT:TakeFuel(amt)
	self.Fuel = self.Fuel-amt/10*FrameTime()
	if self.Fuel < 0 then
		self:Remove()
	end
end

function ENT:Think()
	if self.StartTime and self.StartTime < CurTime() and !self.Started then
		self:StartRocket()
	end
end
