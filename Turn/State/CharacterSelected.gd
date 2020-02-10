extends "res://Turn/State/State.gd"

var MovementArea = load("res://Misc/MovementArea.gd")
var PostSelection = load("res://Turn/State/PostSelection.gd")

var character
var movementArea
var path = []

func _init(c, t, gr).(t, gr):
	character = c
	movementArea = MovementArea.new(grid, character)
	#movementArea.displayMovementArea()
	initialState.characterPosition = character.position
	
	connect("moveDone", self, "onMoveDone")
	
func onMoveDone(direction):
	var gridMapCell = grid.map_to_cell(turn.mapPosition() + direction)
	if gridMapCell != null and grid.inBounds(gridMapCell.mapPosition):
		var gridMapPos = gridMapCell.mapPosition
		var gridMovementAreaPos = movementArea.map_to_movementArea(gridMapPos)
		if grid.inBounds(gridMapPos) and movementArea.inBounds(gridMovementAreaPos) and movementArea.isReachable(gridMovementAreaPos):
			movement.timeout = movement.maxTimeout
			turn.position = grid.map_to_cell(gridMapPos).position
			path = movementArea.calculatePath(turn.position)
			movementArea.drawMovementPath(path)
		
func spaceBarPressed():
	if movementArea.inBounds(movementArea.map_to_movementArea(turn.mapPosition())):
		if path.size() == 0:
			path = movementArea.calculatePath(turn.position)
		character.moveTo(path)
		standbyState.path = movementArea.calculatePath(turn.position)
		character.connect("movementFinished", self, "onMovementFinished")
	
func onMovementFinished():
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