extends Object

signal stateChanged

var grid
var selector

func _init(gr, sel):
	grid = gr
	selector  = sel

func spaceBarPressed(position):
	pass
	
func animateMovement(delta):
	if not selector.isMoving and selector.direction != Vector2():
		selector.targetDir = selector.direction
		if selector.grid.cellVacant(selector.position, selector.direction):
			selector.targetPos = selector.grid.updateChildPos(selector, selector.direction)
			selector.isMoving = true
	elif selector.isMoving:
		selector.speed = selector.maxSpeed
		selector.velocity = selector.speed * selector.targetDir * delta
		
		var distanceToTarget = Vector2(abs(selector.targetPos.x - selector.position.x), abs(selector.targetPos.y - selector.position.y))
		if abs(selector.velocity.x) > distanceToTarget.x:
			selector.velocity.x = distanceToTarget.x * selector.targetDir.x
			selector.isMoving = false
		if abs(selector.velocity.y) > distanceToTarget.y:
			selector.velocity.y = distanceToTarget.y * selector.targetDir.y
			selector.isMoving = false
		
		selector.position += selector.velocity