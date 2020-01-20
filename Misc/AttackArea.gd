extends Object

var grid
var startCell
var character

var attackArea

func _init(gr, ch):
	grid = gr
	character = ch
	startCell = grid.world_to_cell(character.position)
	
	calculateAttackArea()
	
func calculateAttackRange():
	var weapons = character.inventory.getWeapons()
	var maxRange = {
		"start": INF,
		"end": 0
	}
	for weapon in weapons:
		if weapon.attackRange.start < maxRange.start:
			maxRange.start = weapon.attackRange.start
		if weapon.attackRange.end > maxRange.end:
			maxRange.end = weapon.attackRange.end
	return maxRange
	
func calculateAttackArea():
	var characterPos = grid.world_to_map(character.position)
	attackArea = []
	
	var maxRange = calculateAttackRange()
	
	for x in range(-maxRange.end, maxRange.end + 1):
		if grid.inBounds(Vector2(characterPos.x + x, 0)):
			attackArea.append([])
			var startY = -1 * abs(x) + maxRange.end
			var leaveOpen = abs(x) - maxRange.start
			for y in range(-startY, startY + 1):
				if leaveOpen > 0 or abs(y) > abs(leaveOpen):
					if grid.inBounds(Vector2(characterPos.x + x, characterPos.y + y)):
						attackArea[attackArea.size() - 1].append(grid.grid[characterPos.x + x][characterPos.y + y])
						
func displayAttackArea():
	for x in range(attackArea.size()):
		for y in range(attackArea[x].size()):
			if attackArea[x][y].passable:
				attackArea[x][y].indicateAttackable()
				
func clearAttackArea():
	for x in range(attackArea.size()):
		for y in range(attackArea[x].size()):
			print("Clearing indication")
			attackArea[x][y].clearIndications()
				
func map_to_attackArea(mapPosition):
	for x in range(attackArea.size()):
		for y in range(attackArea[x].size()):
			if mapPosition == attackArea[x][y].mapPosition:
				return Vector2(x, y)
	return null
	
func attackArea_to_map(attackAreaPosition):
	return attackArea[attackAreaPosition.x][attackAreaPosition.y]
	
func getRelativeCell(cell, relativeDirection):
	var mapCell = cell.mapPosition
	var targetCell = mapCell + relativeDirection
	var toAttackArea = map_to_attackArea(targetCell)
	if toAttackArea != null:
		return attackArea[toAttackArea.x][toAttackArea.y]
		
func inBounds(cell):
	return cell.x >= 0 and cell.x < attackArea.size() and cell.y >= 0 and cell.y < attackArea[cell.x].size() and attackArea[cell.x][cell.y].passable
	
func getEnemies():
	var arr = []
	for x in attackArea:
		for y in x:
			if y.content != null && y.content.teamNumber != character.teamNumber:
				arr.append(y.content)
	return arr