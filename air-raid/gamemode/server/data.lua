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
	local err = sql.Query("SELECT highscore FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID()))[1].highscore
	if not err then
		print(sql.LastError())
		return false
	end
	return tonumber(err)
end

function meta:IsNew()
	if type(sql.Query("SELECT * FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID()))) != "table" then
		return true
	end
	return false
end

function meta:GetRoundsPlayed()
	return tonumber(sql.Query("SELECT rounds FROM AirRaid WHERE steamid = " .. SQLStr(self:SteamID()))[1].rounds) or 0
end

function meta:SetHighscore(score)
	if type(score) != "number" then return end
	sql.Query("UPDATE AirRaid SET highscore = " .. score .. " WHERE steamid = " .. SQLStr(self:SteamID()))
end

function meta:IncrementRounds()
	local score = self:GetRoundsPlayed() + 1
	sql.Query("UPDATE AirRaid SET rounds = " .. score .. " WHERE steamid = " .. SQLStr(self:SteamID()))
end

function GetTop10()
	return sql.Query("SELECT * FROM AirRaid ORDER BY highscore DESC LIMIT 10") or {{["name"] = "error", ["highscore"] = "error", ["rounds"] = "error"}}
end
