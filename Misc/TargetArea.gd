extends Object

var grid
var character
var attack

var area

func _init(gr, ch, a):
	grid = gr
	character = ch
	attack = a
	
	calculate()
	
func calculate():
	var characterPos = grid.world_to_map(character.position)
	area = []
	
	var items = character.inventory.getWeapons() if attack else character.inventory.getStaffs()
	
	for item in items:
		for x in range(-item.targetRange.end, item.targetRange.end + 1):
			if grid.inBounds(Vector2(characterPos.x + x, 0)):
				var startY = -1 * abs(x) + item.targetRange.end
				var leaveOpen = abs(x) - item.targetRange.start
				for y in range(-startY, startY + 1):
					if leaveOpen > 0 or abs(y) > abs(leaveOpen):
						if grid.inBounds(Vector2(characterPos.x + x, characterPos.y + y)):
							area.append(grid.grid[characterPos.x + x][characterPos.y + y])

func display():
	for x in range(area.size()):
		if area[x].tile.passable:
			area[x].indicate("red" if attack else "green")

func clear():
	for x in range(area.size()):
		area[x].clearIndications()
		
func map_to_area(mapPosition):
	for x in range(area.size()):
		if mapPosition == area[x].mapPosition:
			return x
			
func area_to_map(areaPosition):
	return area[areaPosition]
	
func getRelativeCell(cell, relativeDirection):
	var mapCell = cell.mapPosition
	var targetPosition = mapCell + relativeDirection
	var targetCell = map_to_area(targetPosition)
	if targetCell != null:
		return area[targetCell]
		
func inBounds(x):
	return \
	x >= 0 and \
	x < area.size() and \
	area[x].tile.passable
	
func getTargets():
	var arr = []
	for x in area:
		if x.content != null and x.content != character:
			if attack and x.content.team.teamNumber != character.team.teamNumber:
				arr.append(x.content)
			elif not attack and x.content.team.teamNumber == character.team.teamNumber:
				arr.append(x.content)
	return arr