extends Object

func saveToJSON(world, size, name):
	var json = {
		"map": [],
		"spawnPoints": []
	}
	for x in size.x:
		json.map.append([])
		for y in size.y:
			var tileName = ""
			var tileId = world.get_cell(x, y)
			if tileId == 0:
				tileName = "Dirt"
			elif tileId == 1:
				tileName = "Wall"
			elif tileId == 2:
				tileName = "Grass"
			elif tileId == 3:
				tileName = "Water"
			elif tileId == 4:
				tileName = "Bridge"
			elif tileId == 5:
				tileName = "Plank"
			json.map[json.map.size() - 1].append(tileName)
	var file = File.new()
	file.open("res://Grid/Maps/Castle.json", file.WRITE)
	file.close()