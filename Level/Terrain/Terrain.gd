extends Node2D

onready var PassableShader   = preload("./Passable.shader")
onready var UnpassableShader = preload("./Unpassable.shader")

onready var passableGradient   = preload("./passable.tres")
onready var unpassableGradient = preload("./unpassable.tres")

var content = null

var passable = true
var sprite

var grid
var mapPosition = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	#Duplicate material so it's unique for each Terrain instance...
	$Test.material = $Test.material.duplicate()
	
func init(gr, pos, halfTileSize, pa):
	grid = gr
	position = grid.map_to_world(pos) + halfTileSize
	mapPosition = pos
	passable = pa
	
func clearArrowPath():
	$ArrowStraight.rotation = 0
	$ArrowStraight.hide()

	$ArrowCorner.rotation = 0
	$ArrowCorner.hide()

	$ArrowTop.rotation = 0
	$ArrowTop.hide()	
	
				
func drawPath(from, to):
	if to == Vector2(0, 0):
		if from == Vector2(0, 1):
			$ArrowTop.rotate(0)
			$ArrowTop.show()
		elif from == Vector2(-1, 0):
			$ArrowTop.rotate(PI/2)
			$ArrowTop.show()
		elif from == Vector2(0, -1):
			$ArrowTop.rotate(PI)
			$ArrowTop.show()
		elif from == Vector2(1, 0):
			$ArrowTop.rotate(3*PI/2)
			$ArrowTop.show()
	elif from.y == 0 and to.y == 0:
		$ArrowStraight.rotate(PI/2)
		$ArrowStraight.show()
	elif from.x == 0 and to.x == 0:
		$ArrowStraight.rotate(0)
		$ArrowStraight.show()
	else:
		var sum = from + to
		if sum == Vector2(1, -1):
			$ArrowCorner.rotate(0)
			$ArrowCorner.show()
		elif sum == Vector2(1, 1):
			$ArrowCorner.rotate(PI/2)
			$ArrowCorner.show()
		elif sum == Vector2(-1, 1):
			$ArrowCorner.rotate(PI)
			$ArrowCorner.show()
		elif sum == Vector2(-1, -1):
			$ArrowCorner.rotate(3*PI/2)
			$ArrowCorner.show()
	
func indicateMovement():
	if passable:
		$Test.material.set_shader_param("gradient", passableGradient)
	else:
		$Test.material.set_shader_param("gradient", unpassableGradient)
	
	$Test.material.set_shader_param("mix_amount", 0.7)
	
func clearIndications():
	$Test.material.set_shader_param("mix_amount", 0)
	
func indicateAttackable():
	if passable:
		$Test.material.set_shader_param("gradient", unpassableGradient)
		$Test.material.set_shader_param("mix_amount", 0.7)