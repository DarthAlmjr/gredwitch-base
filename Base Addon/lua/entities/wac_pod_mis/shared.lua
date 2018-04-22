ENT.Base = "wac_pod_base"
ENT.Type = "anim"
ENT.PrintName = "Grediwtch's Guided Missiles"
ENT.Author = wac.author
ENT.Category = wac.aircraft.spawnCategory
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Ammo = 4
ENT.FireRate = 120
ENT.Sequential = true
ENT.MaxRange = 35400
ENT.model = "models/doi/ty_missile.mdl"
ENT.TkAmmo = 1
ENT.Kind = "gb_rocket_hydra"
sound.Add( {
	name = "fire",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = "gunsounds/rocket.wav"
} )

function ENT:Initialize()
	self:base("wac_pod_base").Initialize(self)
	self.baseThink = self:base("wac_pod_base").Think
end


function ENT:SetupDataTables()
	self:base("wac_pod_base").SetupDataTables(self)
	self:NetworkVar("Entity", 0, "Target")
	self:NetworkVar("Vector", 0, "TargetOffset")
	self:NetworkVar( "Int", 0, "TkAmmo" );
	self:NetworkVar( "Int", 0, "Kind" );
end

-- function ENT:canFire()
	-- return IsValid(self:GetTarget())
-- end


function ENT:fireRocket(pos, ang)
	if !self:takeAmmo(self.TkAmmo) then return end
	--if GetConVarNumber("gred_oldrockets") >= 1 then
		local rocket = ents.Create("wac_base_grocket")
		rocket:SetModel ( self.model )
		rocket:SetPos(self:LocalToWorld(pos))
		rocket:SetAngles(ang)
		rocket.Owner = self:getAttacker()
		rocket.Damage = 557
		rocket.Radius = 302
		rocket.Speed = 851
		rocket.Drag = Vector(0,1,1)
		rocket.TrailLength = 200
		rocket.Scale = 15
		rocket.SmokeDens = 1
		rocket.Launcher = self.aircraft
		rocket.target = self:GetTarget()
		rocket.targetOffset = self:GetTargetOffset()
		rocket.calcTarget = function(r)
			-- if !IsValid(r.target) then
				-- return r:GetPos() + r:GetForward()*100
			-- else
				return r.target:LocalToWorld(r.targetOffset)
			-- end
		end
		rocket:Spawn()
		rocket:Activate()
		rocket:StartRocket()
		local ph = rocket:GetPhysicsObject()
		if ph:IsValid() then
			ph:SetVelocity(self:GetVelocity())
			ph:AddAngleVelocity(Vector(30,0,0))
		end
		self:StopSound( "fire" )
		self:EmitSound( "fire" )
		for _,e in pairs(self.aircraft.wheels) do
			if IsValid(e) then
				constraint.NoCollide(e,rocket,0,0)
			end
		end
		constraint.NoCollide(self.aircraft,rocket,0,0)
end


function ENT:fire()
	if self.Sequential then
		self.currentPod = self.currentPod or 1
		self:fireRocket(self.Pods[self.currentPod], self:GetAngles())
		self.currentPod = (self.currentPod == #self.Pods and 1 or self.currentPod + 1)
	else
		for _, pos in pairs(self.Pods) do
			self:fireRocket(pos, self:GetAngles())
		end
	end
end



if SERVER then

	function ENT:Think()
		local ang = self.aircraft:getCameraAngles()
		if ang then
			local pos = self.aircraft:LocalToWorld(self.aircraft.Camera.pos)
			local dir = ang:Forward()
			local tr = util.QuickTrace(pos+dir*20, dir*self.MaxRange, self)
			if tr.HitSky then return
			elseif tr.Hit then
				self:SetTarget(tr.Entity)
				self:SetTargetOffset(tr.Entity:WorldToLocal(tr.HitPos))
			end
		end
		return self:baseThink()
	end

end


function ENT:drawCrosshair()
	surface.SetDrawColor(255,255,255,150)
	local center = {x=ScrW()/2, y=ScrH()/2}
	if IsValid(self:GetTarget()) then
		local pos = self:GetTarget():LocalToWorld(self:GetTargetOffset()):ToScreen()
		pos = {
			x = math.Clamp(pos.x-center.x+math.Rand(-1,1), -20, 20)+center.x,
			y = math.Clamp(pos.y-center.y+math.Rand(-1,1), -20, 20)+center.y
		}
		surface.DrawLine(center.x-20, pos.y, center.x+20, pos.y)
		surface.DrawLine(pos.x, center.y-20, pos.x, center.y+20)
	else
		surface.DrawLine(center.x+20, center.y, center.x+40, center.y)
		surface.DrawLine(center.x-40, center.y, center.x-20, center.y)
		surface.DrawLine(center.x, center.y+20, center.x, center.y+40)
		surface.DrawLine(center.x, center.y-40, center.x, center.y-20)
	end
	surface.DrawOutlinedRect(center.x-20, center.y-20, 40, 40)
	surface.DrawOutlinedRect(center.x-21, center.y-21, 42, 42)
	
	draw.Text({
		text = (
			self:GetNextShot() <= CurTime() and self:GetAmmo() > 0
			and (IsValid(self:GetTarget()) and "LOCK" or "READY")
			or "MSL NOT READY"
		),
		font = "HudHintTextLarge",
		pos = {center.x, center.y+45},
		color = Color(255, 255, 255, 150),
		xalign = TEXT_ALIGN_CENTER
	})
		
end