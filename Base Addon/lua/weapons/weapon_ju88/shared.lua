SWEP.strikedalay        = 5
SWEP.strikeentity       = "gb_bomb_sc100"


SWEP.Category				= "Gredwitch's SWEPs"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Ju 88 bombardment marker"
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 35			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "camera"

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_invisib.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_binos.mdl"	-- Weapon world model
SWEP.Base 				= "bobs_scoped_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("weapons/satellite/targaquired.mp3")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 50		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 1		-- Bullets you start with
SWEP.Primary.KickUp			= 1				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 1		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Axis radio battery"

SWEP.Secondary.ScopeZoom			= 6
SWEP.Secondary.UseParabolic		= false	-- Choose your scope type, 
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= true		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 1

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.IronSightsAng = Vector(50.353, 17.884, -19.428)
SWEP.SightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.SightsAng = Vector(50.353, 17.884, -19.428)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-21.994, 0, 0)

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-19.507, 0, 0) },
	["r-index-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-71.792, 0, 0) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.483, 1.309, 0) },
	["l-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0) },
	["Da Machete"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.263, -1.826), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.507, 0, 0) },
	["r-pinky-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-47.32, 0, 0) },
	["r-ring-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-54.065, 0, 0) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.666, 0, 0) },
	["r-upperarm-movement"] = { scale = Vector(1, 1, 1), pos = Vector(7.394, 2.101, -9.54), angle = Angle(-10.502, -12.632, 68.194) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.526, 0, 0) },
	["r-middle-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-37.065, 0, 0) },
	["r-thumb-mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.816, 18.775, -30.143) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.982, 0, 0) }
}

SWEP.VElements = {
	["binos"] = { type = "Model", model = "models/weapons/binos.mdl", bone = "r-thumb-low", rel = "", pos = Vector(3.907, -0.109, -1.125), angle = Angle(-2.829, 27.281, 105.791), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.PoorBastard = false
SWEP.NextShoot = 0


function SWEP:PrimaryAttack()
if  ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:EmitSound("/radio/axis/carpetbombbegin"..(math.random(1,5))..".ogg")
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:TakePrimaryAmmo(1)
	self.Owner:ChatPrint("Air Strike begins in "..(self.strikedalay).." seconds")
	
	
	if SERVER then
		local PlayerPos = self.Owner:GetShootPos()
		local PlayerAng = self.Owner:GetAimVector()
		
		local trace = {}
		trace.start = PlayerPos + PlayerAng*16
		trace.endpos = PlayerPos + PlayerAng*65536
		trace.filter = {self.Owner}
		local hitpos = util.TraceLine(trace).HitPos
		
		trace.start = hitpos + Vector(0,math.random(-1000,1000),2048)
		trace.endpos = trace.start + Vector(0,math.random(-1000,1000),6144)
		local traceRes = util.TraceLine(trace)
		
		local spawnpos
		spawnpos = hitpos + Vector(0,-2000,1200)
		addPos = Vector(0,400,0)
		
		timer.Simple( (self.strikedalay), function()
			self.Owner:ChatPrint("Air Strike is launched!") 
			self.Weapon:EmitSound("artillery/flyby/bomber_carpetbomb_flyover.ogg", 0, 100, 1, CHAN_AUTO) 
			timer.Simple( 10, function()
				timer.Create("gred_ju88_brun",0.25,14,function()
					self.Rocket = ents.Create(self.strikeentity)
					self.Rocket:SetPos(spawnpos)
					self.Rocket:SetAngles(Angle(0,0,0))
					self.Rocket:Spawn()
					self.Rocket:Activate()
					self.Rocket.Armed = true
					self.RocketPhysObj = self.Rocket:GetPhysicsObject()
					spawnpos = spawnpos + addPos
				end)
			end)
		end)	
	end
end

