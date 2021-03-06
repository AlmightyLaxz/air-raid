bombsfallen = bombsfallen or  0
totalbombsfallen = totalbombsfallen or 0
roundnum = roundnum or 1
SetGlobalInt(0, "bombsfallen")

util.AddNetworkString("ar_round_start_sound")
util.AddNetworkString("ar_leaderboard")

function AR_Start()
	PrintMessage(HUD_PRINTCENTER, "ROUND START")
	net.Start("ar_round_start_sound")
	net.Broadcast()
	roundnum = 1
	timer.Destroy("ar_round")
	bombsfallen = 0
	totalbombsfallen = 0
	game.CleanUpMap()
	for k,v in pairs(player.GetAll()) do
		v:SetTeam(TEAM_PLAYER)
		v:Spawn()
		v:IncrementRounds()
	end
	timer.Create("ar_round", 4, 0, AR_Bombing)
end

function AR_Stop()
	timer.Destroy("ar_round")
	bombsfallen = 0
	roundnum = 1
end

function AR_NextRound()
	roundnum = roundnum + 1
	bombsfallen = 0
	timer.Create("ar_round", math.Clamp(3-roundnum/4, 0.2, 3), 0, AR_Bombing)
end

function AR_Bombing()
	MakeBomb()
	bombsfallen = bombsfallen + 1
	totalbombsfallen = totalbombsfallen + 1
	SetGlobalInt("bombsfallen", totalbombsfallen)
	local stopround = true
	for k,v in pairs(player.GetAll()) do
		if v:Alive() and v:Team() == TEAM_PLAYER then
			stopround = false
		end
	end
	if stopround then
		for k,v in pairs(player.GetAll()) do
			if v:Alive() and v:Team() == TEAM_PLAYER then
				if v:GetHighscore() < totalbombsfallen then
					v:SetHighscore(totalbombsfallen)
				end
			end
		end
		AR_Start()
	end
	if bombsfallen == roundnum*2 then 
		timer.Destroy("ar_round")
		AR_NextRound()
	end
end

function MakeBomb()
	if roundnum < 7 then
		local bomb = ents.Create("ar_bomb")
		bomb:SetPos(RandomPos())
		bomb:SetAngles(Angle(90,0,0))
		bomb:Spawn()
	else
		if math.random(1, roundnum*2) < roundnum then
			local bomb = ents.Create("ar_bomb")
			bomb:SetPos(RandomPos())
			bomb:SetAngles(Angle(90,0,0))
			bomb:Spawn()
		else
			local bomb = ents.Create("ar_bigbomb")
			bomb:SetPos(RandomPos())
			bomb:SetAngles(Angle(90,0,0))
			bomb:Spawn()
		end
	end
end

function RandomPos()
	if game.GetMap() == "ar_test_v1a" then
		local x = math.random(-456, 473)
		local y = math.random(-450, 469)
		local z = 1366
		return Vector(x, y, z)
	else
		local x = math.random(-1519, 1519)
		local y = math.random(-1519, 1519)
		local z = 2164
		return Vector(x, y, z)
	end
end

function GM:PlayerInitialSpawn(ply)
	if not timer.Exists("ar_round") then
		AR_Start()
	end
	if ply:IsNew() then
		ply:NewPlayer()
	end
end

function GM:PlayerSpawn(ply)
	if ply:Team() == TEAM_UNASSIGNED then
		ply:StripWeapons()
		ply:Spectate(OBS_MODE_ROAMING)
		return
	else
		ply:UnSpectate()
	end
	ply:SetDeaths(ply:GetRoundsPlayed())
	ply:SetFrags(ply:GetHighscore())
	ply:StripWeapons()
	ply:Give("weapon_ar_unarmed")
	ply:SetArmor(100)
	ply:SetModel("models/player/group01/male_01.mdl")
end

function GM:PlayerDeath(ply, inf, att)
	if ply:GetHighscore() < totalbombsfallen then
		ply:SetHighscore(totalbombsfallen)
	end
	ply:SetTeam(TEAM_UNASSIGNED)
end

function GM:ShowHelp(ply)
	net.Start("ar_leaderboard")
		net.WriteTable(GetTop10())
	net.Send(ply)
end

function GM:OnPhysgunReload() return false end
function GM:PlayerSpawnSENT(ply) return false end
function GM:PlayerSpawnSWEP(ply) return false end
function GM:PlayerGiveSWEP(ply) return false end
function GM:PlayerSpawnEffect(ply) return false end
function GM:PlayerSpawnVehicle(ply) return false end
function GM:PlayerSpawnNPC(ply) return false end 
function GM:PlayerSpawnRagdoll(ply) return false end
function GM:PlayerSpawnProp(ply) return false end
