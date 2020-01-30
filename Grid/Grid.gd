extends TileMap

onready var Terrain = preload("res://Terrain/Terrain.tscn")
var tileFactory = load("res://Terrain/Tiles/TileFactory.gd").new()
var worldBuilder = load("res://Grid/WorldBuilder.gd").new()

var tileSize = get_cell_size()
var halfTileSize = tileSize / 2

var gridSize = Vector2(0, 0)
var spawnPoints = []
var grid = []

var gameManager

func _ready():
	gameManager = get_parent()
	var file = File.new()
	file.open("res://Grid/Maps/Castle.json", file.READ)
	var mapJSON = JSON.parse(file.get_as_text()).result
	file.close()
	gridSize = Vector2(mapJSON.map.size(), mapJSON.map[0].size() if mapJSON.size() > 0 else 0)
	for team in mapJSON.spawnPoints:
		spawnPoints.append([])
		for spawnPoint in team:
			spawnPoints[spawnPoints.size() - 1].append(Vector2(spawnPoint[0], spawnPoint[1]))
	
	#worldBuilder.saveToJSON(self, gridSize, "Castle")
	
	for x in range(gridSize.x):
		grid.append([])
		for y in range(gridSize.y):
			var terrain = Terrain.instance()
			terrain.init(self, Vector2(x, y), tileFactory.createTile(mapJSON.map[x][y]))
			add_child(terrain)
			grid[x].append(terrain)
	update_bitmask_region(Vector2(0, 0), gridSize)
			
func getSpawnPoint(teamNumber, index):
	return map_to_cell(spawnPoints[teamNumber][index])
	
func inBounds(coords):
	return coords.x < gridSize.x and coords.x >= 0 and coords.y < gridSize.x and coords.y >= 0
			
func isVacant(cell):
	return inBounds(cell.mapPosition)
	
func map_to_cell(mapPos):
	if inBounds(mapPos):
		return grid[mapPos.x][mapPos.y]
	
func world_to_cell(worldPos):
	if inBounds(world_to_map(worldPos)):
		return map_to_cell(world_to_map(worldPos))
	
func updateChildPos(childNode, newCell):
	var oldCell = world_to_cell(childNode.position)
	oldCell.content = null
	newCell.content = childNode
	return newCell.position
	
func getCenter(cell):
	return cell.position + halfTileSize