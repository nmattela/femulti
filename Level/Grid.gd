extends TileMap

var tileSize = get_cell_size()
var halfTileSize = tileSize / 2

var gridSize = Vector2(50, 50)
var grid = []

var unpassables = [
	Vector2(4, 4),
	Vector2(4, 5),
	Vector2(4, 6),
	Vector2(4, 7),
	Vector2(5, 7),
	Vector2(6, 7),
	Vector2(7, 7),
	Vector2(7, 6),
	Vector2(7, 5),
	Vector2(7, 4),
	Vector2(7, 4),
	Vector2(6, 4),
	Vector2(5, 4)
]

var spawnPoints = [
	[Vector2(1, 1), Vector2(3, 1), Vector2(5, 1), Vector2(7, 1), Vector2(9, 1)],
	[Vector2(1, 3), Vector2(3, 3), Vector2(5, 3), Vector2(7, 3), Vector2(9, 3)]
]

var Selector

onready var Terrain = preload("res://Level/Terrain/Terrain.tscn")
onready var Team    = preload("res://Team/Team.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(gridSize.x):
		grid.append([])
		for y in range(gridSize.y):
			var terrain = Terrain.instance()
			terrain.init(self, Vector2(x, y), halfTileSize, true)#unpassables.find(Vector2(x, y)) == -1)
			add_child(terrain)
			grid[x].append(terrain)
			
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