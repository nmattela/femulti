extends Object

func createTile(tileName):
	return load("res://Terrain/Tiles/{tn}.gd".format({
		"tn": tileName
	})).new()