extends TileMap

onready var Terrain = preload("res://Terrain/Terrain.tscn")
var tileFactory = load("res://Terrain/Tiles/TileFactory.gd").new()
var worldBuilder = load("res://Grid/WorldBuilder.gd").new()

var tileSize = get_cell_size()
var halfTileSize = tileSize / 2

var map
var grid = []

var gameManager

func _ready():
	gameManager = get_parent()
	
func init(m):
	map = m
	
	#worldBuilder.saveToJSON(self, Vector2(20, 20), "Castle_Small")
	
	for x in range(map.size.x):
		grid.append([])
		for y in range(map.size.y):
			var terrain = Terrain.instance()
			terrain.init(self, Vector2(x, y), tileFactory.createTile(map.content[x][y]))
			add_child(terrain)
			grid[x].append(terrain)
	update_bitmask_region(Vector2(0, 0), map.size)
			
func getSpawnPoint(teamNumber, index):
	return map_to_cell(map.spawnPoints[teamNumber][index])
	
func inBounds(coords):
	return coords.x < map.size.x and coords.x >= 0 and coords.y < map.size.x and coords.y >= 0
			
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