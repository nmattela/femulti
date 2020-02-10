extends Object

var PriorityQueue = load("res://Misc/PriorityQueue.gd")

var grid
var character
var startCell
var centerMovementArea

var movementArea
var howToReach
var distances

func _init(gr, ch):
	grid = gr
	character = ch
	startCell = grid.world_to_cell(character.position)
	
	calculateMovementArea()

	for x in range(movementArea.size()):
		for y in range(movementArea[x].size()):
			if movementArea[x][y] == startCell:
				centerMovementArea = Vector2(x, y)
	
	calculateMovementDistanceAndReach()
	
func calculateMovementArea():
	var characterPos = grid.world_to_map(character.position)
	movementArea = []
	for x in range(-character.type.maxMovement, character.type.maxMovement + 1):
		if grid.inBounds(Vector2(characterPos.x + x, 0)):
			movementArea.append([])
			var start = -1 * abs(x) + character.type.maxMovement
			for y in range(-start, start + 1):
				if grid.inBounds(Vector2(characterPos.x + x, characterPos.y + y)):
					movementArea[movementArea.size() - 1].append(grid.grid[characterPos.x + x][characterPos.y + y])
					#grid.grid[characterPos.x + x][characterPos.y + y].get_node("Label").text = "({x}, {y})".format({"x": movementArea.size() - 1, "y": movementArea[movementArea.size() - 1].size() - 1})
				
func calculateMovementDistanceAndReach():
	distances = []
	for x in range(movementArea.size()):
		distances.append([])
		for y in range(movementArea[x].size()):
			distances[x].append(INF)
	distances[centerMovementArea.x][centerMovementArea.y] = 0
	
	howToReach = []
	for x in range(movementArea.size()):
		howToReach.append([])
		for y in range(movementArea[x].size()):
			howToReach[x].append(null)
	howToReach[centerMovementArea.x][centerMovementArea.y] = movementArea[centerMovementArea.x][centerMovementArea.y]
	
	var pq = PriorityQueue.new([])
	for x in range(movementArea.size()):
		for y in range(movementArea[x].size()):
			pq.insert(INF, Vector2(x, y))
	pq.change_priority(pq.get_queue().find(Vector2(centerMovementArea.x, centerMovementArea.y)), 0)
	
	while pq.get_size() != 0:
		var distanceAndNode   = pq.remove_root(true)
		var neighbors = getNeighboringCells(distanceAndNode[1])
		for neighbor in neighbors:
			if (distances[distanceAndNode[1].x][distanceAndNode[1].y] + 1) < distances[neighbor.x][neighbor.y]:
				distances[neighbor.x][neighbor.y] = distances[distanceAndNode[1].x][distanceAndNode[1].y] + 1
				howToReach[neighbor.x][neighbor.y] = movementArea[distanceAndNode[1].x][distanceAndNode[1].y]
				#movementArea[neighbor.x][neighbor.y].get_node("Label").text = "({x}, {y})".format({"x": distanceAndNode[1].x, "y": distanceAndNode[1].y})
			pq.change_priority(pq.get_queue().find(neighbor), distances[neighbor.x][neighbor.y])
	
func displayMovementArea():
	for x in range(movementArea.size()):
		for y in range(movementArea[x].size()):
			var neighbors = getNeighboringCells(Vector2(x, y))
			var neighborsUnreachable = true
			for neighbor in neighbors:
				if isReachable(neighbor) and movementArea[neighbor.x][neighbor.y].tile.passable:
					neighborsUnreachable = false
			if isReachable(Vector2(x, y)) and not neighborsUnreachable:
				movementArea[x][y].indicateMovement()
				
func clearMovementArea():
	for x in range(movementArea.size()):
		for y in range(movementArea[x].size()):
			movementArea[x][y].clearIndications()
				
func drawMovementPath(path):
	clearMovementPath()
	for p in path:
		p.terrain.drawPath(p.from, p.to)
		
func clearMovementPath():
	for x in movementArea:
		for y in x:
			y.clearArrowPath()
	
func getNeighboringCells(cell):
	
	var mapCell = movementArea_to_map(cell)

	var neighbors = [
		map_to_movementArea(Vector2(mapCell.x    , mapCell.y - 1)),
		map_to_movementArea(Vector2(mapCell.x + 1, mapCell.y    )),
		map_to_movementArea(Vector2(mapCell.x    , mapCell.y + 1)),
		map_to_movementArea(Vector2(mapCell.x - 1, mapCell.y    ))
	]
	var returnArray = []
	for neighbor in neighbors:
		if inBounds(neighbor):
			returnArray.append(neighbor)
	return returnArray
	
func inBounds(cell):
	return cell.x >= 0 \
	and cell.x < movementArea.size() \
	and cell.y >= 0 \
	and cell.y < movementArea[cell.x].size() \
	and movementArea[cell.x][cell.y].tile.passable \
	and (movementArea[cell.x][cell.y].content == null or character.team.isTeamMember(movementArea[cell.x][cell.y].content))
	
func isReachable(cell):
	return howToReach[cell.x][cell.y] != null
	
func map_to_movementArea(mapPosition):
	var centerMap = movementArea[centerMovementArea.x][centerMovementArea.y].mapPosition
	var x = centerMovementArea.x + (mapPosition.x - centerMap.x)
	var y
	if x < movementArea.size():
		var topCellOfCentralX = movementArea[centerMovementArea.x][0]
		var topCellOfPositionX = movementArea[x][0]
		var differenceInY = abs(topCellOfCentralX.mapPosition.y - topCellOfPositionX.mapPosition.y)
		y = centerMovementArea.y + (mapPosition.y - centerMap.y) - differenceInY
	else:
		x = -1
		y = -1
	
	return Vector2(x, y)
	
func movementArea_to_map(movementAreaPosition):
	return movementArea[movementAreaPosition.x][movementAreaPosition.y].mapPosition
	
func calculatePath(targetPos):
	var target = map_to_movementArea(grid.world_to_map(targetPos))
	
	var path = [movementArea[target.x][target.y]]
	while path.front() != movementArea[centerMovementArea.x][centerMovementArea.y]:
		var closest = path.front()
		var relativeMovementArea = map_to_movementArea(closest.mapPosition)
		path.push_front(howToReach[relativeMovementArea.x][relativeMovementArea.y])

	var flowPath = []
	for p in range(path.size()):
		var curr = path[p]
		var prev = path[p-1] if p > 0 else curr
		var next = path[p+1] if p < path.size() - 1 else curr

		flowPath.append({
			"terrain": path[p],
			"from": prev.mapPosition - curr.mapPosition,
			"to": next.mapPosition - curr.mapPosition
		})
	return flowPath