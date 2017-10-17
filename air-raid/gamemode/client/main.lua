util.PrecacheSound("vo/npc/male01/heretheycome01.wav") 

net.Receive("ar_round_start_sound", function()
LocalPlayer():EmitSound("vo/npc/male01/heretheycome01.wav")
end)

surface.CreateFont( "stb24", {
	font = "Trebuchet24",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

function ARHUD()
	local bf = GetGlobalInt("bombsfallen")
	draw.RoundedBox(3, 5, ScrH() - 35, 300, 33, Color(24, 24, 24, 150))
	draw.SimpleText(bf, "stb24", 10, ScrH() - 30, Color(255, 255, 255, 200), 0, 0)
end
hook.Add("HUDPaint", "ARHUD", ARHUD)