function GM:ScoreboardShow()
	Scoreboard = vgui.Create("DFrame")
	Scoreboard:SetTitle("")
	Scoreboard:SetSize(700,405)
	Scoreboard:Center()
	Scoreboard:SetDraggable(false)
	Scoreboard:ShowCloseButton(false)
	function Scoreboard:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 250))
		draw.SimpleText(GetHostName(), "AR_LeaderboardFont", w/2, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local columns = vgui.Create("DPanel", Scoreboard)
	columns:Dock(TOP)
	columns:DockMargin(2,2,2,4)
	function columns:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
	end
	
	local rowdata = {
		{"#", 100, Color(150, 150, 150, 255)},
		{"Name", 240, Color(200, 200, 200, 255)},
		{"Best Score", 200, Color(150, 150, 150, 255)},
		{"Total Rounds", 150, Color(200, 200, 200, 255)}
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
	
	local list = vgui.Create("DIconLayout", Scoreboard)
	list:SetSpaceY(5)
	list:SetSpaceX(5)
	list:Dock(FILL)

	local players = player.GetAll()
	table.sort(players, function(a, b)
		return a:Frags() > b:Frags()
	end)

	for k,v in pairs(players) do
		local listitem = list:Add("DPanel")
		listitem:SetHeight(30)
		listitem:Dock(TOP)
		listitem:DockMargin(2,2,2,2)
		function listitem:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 250))
			draw.SimpleText("#"..k, "AR_LeaderboardFont", 10, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v:Name(), "AR_LeaderboardFont", 110, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v:Frags(), "AR_LeaderboardFont", 350, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v:Deaths(), "AR_LeaderboardFont", 550, h/2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

function GM:ScoreboardHide()
	Scoreboard:Close()
end
