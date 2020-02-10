extends PanelContainer

func init(team):
	print(team.teamNumber)
	theme = theme.duplicate()
	var style = theme.get_stylebox("panel", "PanelContainer")
	theme.set_stylebox("panel", "PanelContainer", style.duplicate())
	theme.get_stylebox("panel", "PanelContainer").bg_color = Color("#3850e0") if team.teamNumber == 0 else Color("#a83028")
	$ListSetupSplitter.init(team)