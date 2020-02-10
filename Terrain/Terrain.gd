extends Node2D

var arrowCorner = load("res://Terrain/arrow/arrow_corner.png")
var arrowStraight = load("res://Terrain/arrow/arrow_straight.png")
var arrowTop = load("res://Terrain/arrow/arrow_top.png")

const red  = "aaae0707"
const blue = "aa006fb9"
const green = "aa06b900"

var content = null

var tile

var grid
var mapPosition = Vector2()

func _ready():
	pass
	
func init(gr, pos, t):
	grid = gr
	position = grid.map_to_world(pos) + grid.halfTileSize
	mapPosition = pos
	tile = t
	grid.set_cell(mapPosition.x, mapPosition.y, tile.id)
	
func clearArrowPath():
	$Arrow.rotation = 0
	$Arrow.hide()
	
func drawPath(from, to):
	if to == Vector2(0, 0):
		$Arrow.texture = arrowTop
		if from == Vector2(0, 1):
			$Arrow.rotate(0)
		elif from == Vector2(-1, 0):
			$Arrow.rotate(PI/2)
		elif from == Vector2(0, -1):
			$Arrow.rotate(PI)
		elif from == Vector2(1, 0):
			$Arrow.rotate(3*PI/2)
	elif from.y == 0 and to.y == 0:
		$Arrow.texture = arrowStraight
		$Arrow.rotate(PI/2)
	elif from.x == 0 and to.x == 0:
		$Arrow.texture = arrowStraight
		$Arrow.rotate(0)
	else:
		$Arrow.texture = arrowCorner
		var sum = from + to
		if sum == Vector2(1, -1):
			$Arrow.rotate(0)
		elif sum == Vector2(1, 1):
			$Arrow.rotate(PI/2)
		elif sum == Vector2(-1, 1):
			$Arrow.rotate(PI)
		elif sum == Vector2(-1, -1):
			$Arrow.rotate(3*PI/2)
	$Arrow.show()
	
func indicate(c):
	var color
	if c == "red":
		color = red
	elif c == "blue":
		color = blue
	elif c == "green":
		color = green
	
	$Indication.color = color
	$Indication.show()
			
func indicateMovement():
	$Indication.color = blue
	$Indication.show()
	
func clearIndications():
	$Indication.hide()
	
func indicateAttackable():
	if tile.passable:
		$Indication.color = red
		$Indication.show()