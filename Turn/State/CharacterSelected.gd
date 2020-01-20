extends "res://Turn/State/State.gd"

var MovementArea = load("res://Misc/MovementArea.gd")
var PostSelection = load("res://Turn/State/PostSelection.gd")

var character
var movementArea

func _init(c, t, gr).(t, gr):
	character = c
	movementArea = MovementArea.new(grid, character)
	movementArea.displayMovementArea()
	initialState.characterPosition = character.position
	
func move(delta, direction):
	if movement.timeout == 0:
		if direction != Vector2():
			var gridMapCell = grid.map_to_cell(turn.mapPosition() + direction)
			if gridMapCell != null and grid.inBounds(gridMapCell.mapPosition):
				var gridMapPos = gridMapCell.mapPosition
				var gridMovementAreaPos = movementArea.map_to_movementArea(gridMapPos)
				if grid.inBounds(gridMapPos) and movementArea.inBounds(gridMovementAreaPos) and movementArea.isReachable(gridMovementAreaPos):
					movement.timeout = movement.maxTimeout
					turn.position = grid.map_to_cell(gridMapPos).position
					movementArea.drawMovementPath(movementArea.calculatePath(turn.position))
	else:
		movement.timeout -= 1
		
func spaceBarPressed():
	var path = movementArea.calculatePath(turn.position)
	character.moveTo(path)
	standbyState.path = movementArea.calculatePath(turn.position)
	emit_signal("stateChanged", PostSelection.new(character, turn, grid))
	
func standby():
	movementArea.clearMovementArea()
	movementArea.clearMovementPath()
	
func resume():
	movementArea.displayMovementArea()
	movementArea.drawMovementPath(standbyState.path)
	character.position = initialState.characterPosition

func destroy():
	standby()
	character.position = initialState.characterPosition
	.destroy()