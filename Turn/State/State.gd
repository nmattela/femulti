extends Object

signal stateChanged
signal stateReturned
signal done
signal moveDone

var movement = {
	"isMoving": false,
	"velocity": Vector2(0, 0),
	"speed": 0,
	"maxSpeed": 400,
	"targetPos": Vector2(0, 0),
	"targetDir": Vector2(0, 0),
	"timeout": 0,
	"maxTimeout": 10
}

var standbyState = {
	"selectorPosition": null,
	"path": []
}

var initialState = {
	"characterPosition": null
}

var grid
var turn

func _init(t, gr):
	grid = gr
	turn = t
	
func standby():
	pass
	
func resume():
	pass
	
func destroy():
	call_deferred("free")
	
func move(delta, direction):
	if !movement.isMoving and direction != Vector2():
		movement.targetDir = direction
		var targetCell = grid.map_to_cell(turn.mapPosition() + direction)
		if targetCell != null and grid.inBounds(targetCell.mapPosition):
			movement.targetPos = targetCell.position
			movement.isMoving = true
	elif movement.isMoving:
		movement.speed = movement.maxSpeed
		movement.velocity = movement.speed * movement.targetDir * delta
		var distanceToTarget = Vector2(abs(movement.targetPos.x - turn.position.x), abs(movement.targetPos.y - turn.position.y))
		if abs(movement.velocity.x) > distanceToTarget.x:
			movement.velocity.x = distanceToTarget.x * movement.targetDir.x
			movement.isMoving = false
		if abs(movement.velocity.y) > distanceToTarget.y:
			movement.velocity.y = distanceToTarget.y * movement.targetDir.y
			movement.isMoving = false
			
		turn.position += movement.velocity
		
		if not movement.isMoving:
			emit_signal("moveDone", direction)
		
func spaceBarPressed():
	pass