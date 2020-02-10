extends Object

var size = Vector2(0, 0)
var content = []
var spawnPoints = []
var maxPlayers = INF

func _init(mapFile):
	var file = File.new()
	file.open(mapFile, file.READ)
	var mapJSON = JSON.parse(file.get_as_text()).result
	file.close()

	size = Vector2(mapJSON.map.size(), mapJSON.map[0].size() if mapJSON.size() > 0 else 0)
	content = mapJSON.map
	
	for team in mapJSON.spawnPoints:
		spawnPoints.append([])
		var players = 0
		for spawnPoint in team:
			players += 1
			spawnPoints[spawnPoints.size() - 1].append(Vector2(spawnPoint[0], spawnPoint[1]))
		if players < maxPlayers:
			maxPlayers = players
	