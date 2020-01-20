extends KinematicBody2D

signal movementFinished

onready var ColorChanger = load("res://Character/ColorChanger.gd")
onready var Inventory    = load("res://Character/Inventory.gd")
onready var Sword        = load("res://Item/ItemTypes/Weapons/Sword.gd")


var grid
var initialCell

var type
var colorChanger
var inventory
var currentCell
var teamNumber
var characterNumber

var maxMovement = 5
var health
var dead = false

var movement = {
	"velocity": Vector2(0, 0),
	"speed": 0,
	"maxSpeed": 200,
	"isMoving": false,
	"path": [],
	"targetCell": null,
	"targetDir": Vector2()
}

func _ready():
	#Duplicate material so it's unique for each Terrain instance...
	$Sprite.material = $Sprite.material.duplicate()
	
func init(gr, teamNo, characterNo, strategyType):
	grid = gr
	teamNumber = teamNo
	characterNumber = characterNo
	inventory = Inventory.new()
	inventory.addItem(Sword.new())
	
	type = strategyType.new()
	health = type.maxHealth
	$Sprite.texture = type.texture
	
	colorChanger = ColorChanger.new(self)
	
	var spawnPoint = grid.getSpawnPoint(teamNumber, characterNumber)
	currentCell = spawnPoint
	initialCell = spawnPoint
	position = currentCell.position
	grid.updateChildPos(self, currentCell)
	
func updateGridPos():
	initialCell.content = null
	var newCell = grid.world_to_cell(position)
	newCell.content = self
	initialCell = newCell
	
func moveTo(p):
	movement.path = p
	movement.targetCell = movement.path.pop_front().terrain
	movement.isMoving = true
	
func indicateUnmovable():
	colorChanger.setUsedColor()
	
func indicateMovable():
	colorChanger.setTeamColor()
	
func die():
	dead = true
	hide()

func _process(delta):
	if movement.targetCell == currentCell and movement.path.size() > 0:
		movement.targetCell = movement.path.pop_front().terrain
		movement.targetDir = movement.targetCell.mapPosition - currentCell.mapPosition
		movement.isMoving = true
	elif movement.isMoving:
		
		type.animateMovement(movement.targetDir)
		
		movement.speed = movement.maxSpeed
		movement.velocity = movement.speed * movement.targetDir * delta
		var distanceToTarget = Vector2(abs(movement.targetCell.position.x - position.x), abs(movement.targetCell.position.y - position.y))
		if abs(movement.velocity.x) > distanceToTarget.x:
			movement.velocity.x = distanceToTarget.x * movement.targetDir.x
		if abs(movement.velocity.y) > distanceToTarget.y:
			movement.velocity.y = distanceToTarget.y * movement.targetDir.y
		if movement.velocity == distanceToTarget:
			movement.isMoving = false
			currentCell = movement.targetCell
			if movement.path.size() == 0:
				
				type.animateMovement(Vector2(0, 0))
				
				emit_signal("movementFinished")
		position += movement.velocity