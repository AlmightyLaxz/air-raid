surface.CreateFont("LeaderboardFont", {
	font = "Arial",
	size = 20,
	weight = 650,
	antialias = true,
})

function leaderboard(players)
	local frame = vgui.Create("DFrame")
	frame:SetTitle("")
	frame:SetSize(700,405)
	frame:Center()
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()
	function frame:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 250))
		draw.SimpleText("Leaderboard", "LeaderboardFont", 10, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	local columns = vgui.Create("DPanel", frame)
	columns:Dock(TOP)
	columns:DockMargin(2,2,2,4)
	function columns:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
	end
	
	local rowdata = {
		{"#", 100, Color(150, 150, 150, 255)},
		{"Name", 240, Color(200, 200, 200, 255)},
		{"Top Score", 200, Color(150, 150, 150, 255)},
		{"Rounds Played", 150, Color(200, 200, 200, 255)}
	}
	
	for k,v in pairs(rowdata) do
		local row = vgui.Create("DPanel", columns)
		row:Dock(LEFT)
		row:SetWidth(v[2])
		function row:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, v[3])
			draw.SimpleText(v[1], "LeaderboardFont", 10, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	
	local list = vgui.Create("DIconLayout", frame)
	list:SetSpaceY(5)
	list:SetSpaceX(5)
	list:Dock(FILL)
	for k,v in pairs(players) do
		PrintTable(v)
		local listitem = list:Add("DPanel")
		listitem:SetHeight(30)
		listitem:Dock(TOP)
		listitem:DockMargin(2,2,2,2)
		function listitem:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 250))
			draw.SimpleText("#"..k, "LeaderboardFont", 10, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.name, "LeaderboardFont", 110, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.highscore, "LeaderboardFont", 350, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.rounds, "LeaderboardFont", 550, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end
--leaderboard client
net.Receive("leaderboard", function()
	leaderboard(net.ReadTable())
end)

--leaderboard server
//util.AddNetworkString("leaderboard")

net.Receive("leaderboard", function(len, ply)
	net.Start("leaderboard")
		net.WriteTable(GetTop10())
	net.Send(ply)
end)


--sql shit--

if not sql.TableExists("AirRaid") then
	sql.Query("CREATE TABLE AirRaid(steamid STRING, name STRING, highscore INT DEFAULT 0, rounds INT DEFAULT 0)")
end

local meta = FindMetaTable("Player")

function meta:NewPlayer()
	local err = sql.Query("INSERT INTO AirRaid (steamid, name) VALUES(" .. SQLStr(self:SteamID()) .. ", " .. SQLStr(self:Name()) .. ")")
	if not err then
		print(sql.LastError())
	end
end

function meta:GetHighscore()
	local err = sql.Query("SELECT highscore FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID()))
	if not err then
		print(sql.LastError())
		return false
	end
	return err
end

function meta:IsNew()
	if sql.Query("SELECT * FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID())) then
		return true
	end
	return false
end

function meta:GetRoundsPlayed()
	return sql.Query("SELECT rounds FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID())) or 0
end

function meta:IncrementScore()
	local score = self:GetHighscore() + 1
	sql.Query("UPDATE AirRaid SET highscore = " .. score .. " WHERE steamid = " .. SQLStr(self:SteamID()))
end

function meta:IncrementRounds()
	local score = self:GetRoundsPlayed() + 1
	sql.Query("UPDATE AirRaid SET highscore = " .. score .. " WHERE steamid = " .. SQLStr(self:SteamID()))
end

function GetTop10()
	return sql.Query("SELECT * FROM AirRaid ORDER BY highscore DESC LIMIT 10") or {["name"] = "error", ["highscore"] = "error", ["rounds"] = "error"}
end

hook.Add("PlayerInitialSpawn", "ar_spawn", function(ply)
	if ply:IsNew() then
		ply:NewPlayer()
	end
end)