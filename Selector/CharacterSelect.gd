extends "res://Selector/SelectorState.gd"

var MovementArea = load("res://Misc/MovementArea.gd")
var PostSelect   = load("res://Selector/PostSelect.gd")

var character
var startCell
var movementArea

var movementTimeout = 10
var timeout = 0

func _init(c, gr, sel).(gr, sel):
	startCell = c
	character = startCell.content
	movementArea = MovementArea.new(grid, startCell)
	movementArea.displayMovementArea()
	character.connect("movementFinished", self, "clearMovement")
	
func clearMovement():
	movementArea.clearMovementPath()
	movementArea.clearMovementArea()

func spaceBarPressed(position):
	character.moveTo(movementArea.calculatePath(position))
	emit_signal("stateChanged", PostSelect.new(character, grid, selector))
	
func animateMovement(delta):
	if timeout == 0:
		if selector.direction != Vector2():
			var gridMapPos = grid.world_to_map(selector.position) + selector.direction
			var gridMovementAreaPos = movementArea.map_to_movementArea(gridMapPos)
			if grid.inBounds(gridMapPos) and movementArea.inBounds(gridMovementAreaPos) and movementArea.isReachable(gridMovementAreaPos):
				timeout = movementTimeout
				selector.position = selector.grid.updateChildPos(selector, selector.direction)
				movementArea.drawMovementPath(selector.position)
	else:
		timeout -= 1
	