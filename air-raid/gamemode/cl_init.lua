include("shared.lua")
include("client/main.lua")
include("client/leaderboard.lua")

RunConsoleCommand("cl_drawspawneffect", "0")
RunConsoleCommand("cl_updaterate", "1000")
RunConsoleCommand("cl_interp", "0")
RunConsoleCommand("rate", "1048576")
