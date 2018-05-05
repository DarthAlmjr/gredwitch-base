ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Category		= "Gredwitch's Stuff"
ENT.PrintName 		= "[EMP]MG81Z"
ENT.Author			= "Gredwitch"
ENT.Spawnable		= true
ENT.AdminSpawnable	= false
ENT.tracer = 0
ENT.tracerConvar=GetConVarNumber("gred_tracers")
ENT.TurretFloatHeight=3
ENT.TurretModelOffset=Vector(0,0,40)
ENT.TurretTurnMax=0.7

ENT.LastShot=0
ENT.ShotInterval=0.016

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"Shooter")
	self:DTVar("Entity",1,"ShootPos")
end

function ENT:SetShooter(plr)
	self.Shooter=plr
	self:SetDTEntity(0,plr)
end

function ENT:GetShooter(plr)
	if SERVER then
		return self.Shooter
	elseif CLIENT then
		return self:GetDTEntity(0)
	end
end

function ENT:Use(plr)
	
	if not self:ShooterStillValid() then
		self:SetShooter(plr)
		self:StartShooting()
		self.ShooterLast=plr
	else
		if plr==self.Shooter then
			self:SetShooter(nil)
			self:FinishShooting()
			
		end
	end
end

function ENT:ShooterStillValid()
	local shooter=nil
	if SERVER then
		shooter=self.Shooter
	elseif CLIENT then
		shooter=self:GetDTEntity(0)
	end
	
	return IsValid(shooter) and shooter:Alive() and ((self:GetPos()+self.TurretModelOffset):Distance(shooter:GetShootPos())<=60)
end

function ENT:DoShot()
	if self.LastShot+self.ShotInterval<CurTime() then
		if IsValid(self.shootPos) and SERVER then
			local getBullet=self:GetAttachment(self.MuzzleAttachment)
			local vPoint = getBullet.Pos-- + Vector(0,40,0)
			local aPoint = getBullet.Ang + Angle(0,90,0)
			
			local effectdata = EffectData()
			
			effectdata:SetStart(vPoint)
			effectdata:SetOrigin(vPoint)
			effectdata:SetAngles(aPoint)
			effectdata:SetEntity(self)
			effectdata:SetScale( 1 )
			util.Effect( "MuzzleEffect", effectdata )
			
			local b=ents.Create("wac_base_7mm")
			
			ang = (aPoint + Angle(math.Rand(-0.5,0.5), math.Rand(-0.5,0.5), math.Rand(-0.5,0.5)))
			b:SetPos(vPoint)
			b:SetAngles(ang)
			b.Speed=1000
			b.Size=0--13
			b.Width=0--1
			b.Damage=40
			b.Radius=70
			b.sequential=1
			b.gunRPM=3600
			b.Owner= self.Shooter
			b:Spawn()
			self.tracer = self.tracer + 1
			if self.tracer >= self.tracerConvar then
				util.SpriteTrail(b, 0, Color(255,255,0), false, 5, 5, 0.05, 1/(15+1)*0.5, "trails/laser.vmt")
				util.SpriteTrail(b, 0, Color(0,255,0), false, 13/2, 13/8, 13/350, 1/13/2*0.5, "trails/smoke.vmt")
				self.tracer = 0
			end
			
			self:GetPhysicsObject():ApplyForceCenter( self:GetRight()*50000 )
		end
	self.LastShot=CurTime()
	end
end

function ENT:Think()
	
	if not IsValid(self.turretBase) and SERVER then
		SafeRemoveEntity(self)
	else
		if IsValid(self) then
			if SERVER then
				self.BasePos=self.turretBase:GetPos()
				self.OffsetPos=self.turretBase:GetAngles():Up()*1
			end
			if self:ShooterStillValid() then
				if SERVER then
					local offsetAng=(self:GetAttachment(self.MuzzleAttachment).Pos-self:GetDesiredShootPos()):GetNormal()
					local offsetDot=self.turretBase:GetAngles():Right():DotProduct(offsetAng)
					local HookupPos=self:GetAttachment(self.HookupAttachment).Pos
					if offsetDot>=self.TurretTurnMax then
						local offsetAngNew=offsetAng:Angle()
						offsetAngNew:RotateAroundAxis(offsetAngNew:Up(),90)
						
						self.OffsetAng=offsetAngNew
					end
				end
				local pressKey=IN_BULLRUSH
				if CLIENT and game.SinglePlayer() then
					pressKey=IN_ATTACK
				end
				self.Firing=self:GetShooter():KeyDown(pressKey)
			else
				self.Firing=false
				if SERVER then
					self.OffsetAng=self.turretBase:GetAngles()
					
					self:SetShooter(nil)
					self:FinishShooting()
				end
			end
			if self.Firing then
				self:DoShot()
			end
			self:NextThink(CurTime())
			return true
		end
	end
end	