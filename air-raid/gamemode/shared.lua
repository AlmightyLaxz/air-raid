GM.Name = "Air Raid"
GM.Author = "Almighty Laxz"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

DeriveGamemode("sandbox")

function GM:CreateTeams()
	TEAM_PLAYER = 1
	TEAM_UNASSIGNED = 0
	team.SetUp(TEAM_PLAYER, "Alive", Color(0, 255, 20, 255))
	team.SetUp(TEAM_UNASSIGNED, "Dead", Color(70, 70, 70, 255))
end