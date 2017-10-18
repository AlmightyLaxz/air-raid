surface.CreateFont("AR_LeaderboardFont", {
	font = "Arial",
	size = 20,
	weight = 650,
	antialias = true,
})

function AR_Leaderboard(players)
	local frame = vgui.Create("DFrame")
	frame:SetTitle("")
	frame:SetSize(700,405)
	frame:Center()
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()
	function frame:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 250))
		draw.SimpleText("Leaderboard", "AR_LeaderboardFont", 10, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
			draw.SimpleText(v[1], "AR_LeaderboardFont", 10, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	
	local list = vgui.Create("DIconLayout", frame)
	list:SetSpaceY(5)
	list:SetSpaceX(5)
	list:Dock(FILL)
	for k,v in pairs(players) do
		local listitem = list:Add("DPanel")
		listitem:SetHeight(30)
		listitem:Dock(TOP)
		listitem:DockMargin(2,2,2,2)
		function listitem:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 250))
			draw.SimpleText("#"..k, "AR_LeaderboardFont", 10, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.name, "AR_LeaderboardFont", 110, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.highscore, "AR_LeaderboardFont", 350, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.rounds, "AR_LeaderboardFont", 550, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

net.Receive("ar_leaderboard", function()
	AR_Leaderboard(net.ReadTable())
end)
