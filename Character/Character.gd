extends KinematicBody2D

signal movementFinished

onready var Inventory    = load("res://Character/Inventory.gd")
onready var Sword        = load("res://Item/ItemTypes/Weapons/Sword.gd")
onready var Longbow      = load("res://Item/ItemTypes/Weapons/Longbow.gd")


var grid
var initialCell

var type
var inventory
var currentCell
var team
var characterNumber

#Stats
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
	z_index = 1
	
func init(gr, t, characterNo, strategyType):
	grid = gr
	team = t
	characterNumber = characterNo
	inventory = Inventory.new()
	inventory.addItem(Sword.new())
	inventory.addItem(Longbow.new())
	
	type = strategyType.new(team.teamNumber)
	health = type.maxHealth
	$Sprite.texture = type.texture
	
	var spawnPoint = grid.getSpawnPoint(team.teamNumber, characterNumber)
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
	
func indicateIdle():
	$Sprite.material.set_shader_param("mix_amount", 0.5)
	
func indicateUnmovable():
	$Sprite.material.set_shader_param("mix_amount", 1)
	
func indicateMovable():
	$Sprite.material.set_shader_param("mix_amount", 0)
	
func die():
	print("Character from team {x} at {pos} died".format({"x": team.teamNumber, "pos": grid.world_to_cell(position).mapPosition}))
	dead = true
	if initialCell.content == self:
		initialCell.content = null
	elif grid.world_to_cell(position).content == self:
		grid.world_to_cell(position).content = null
	hide()

func _process(delta):
	if movement.targetCell == currentCell and movement.path.size() > 0:
		movement.targetCell = movement.path.pop_front().terrain
		movement.targetDir = movement.targetCell.mapPosition - currentCell.mapPosition
		movement.isMoving = true
	elif movement.isMoving:
		
		type.animateMovement(movement.targetDir)
		$Sprite.texture = type.texture
		
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
				$Sprite.texture = type.texture
				
				emit_signal("movementFinished")
		position += movement.velocity
		
		
func calculateAttack(enemy, weapon):
	var moves = []
	var enemyWeapon = enemy.inventory.getSelectedWeapon()
	if enemy.type.agility > type.agility * 1.5:
		moves.append(createMove(enemy, self, enemyWeapon))
		moves.append(createMove(self, enemy, weapon))
	else:
		moves.append(createMove(self, enemy, weapon))
		moves.append(createMove(enemy, self, enemyWeapon))
	if enemy.type.agility > type.agility * 2:
		moves.append(createMove(enemy, self, enemyWeapon))
	elif type.agility > enemy.type.agility * 2:
		moves.append(createMove(self, enemy, weapon))
		
	var returnMoves = []
	for move in moves:
		if move != null:
			returnMoves.append(move)
	return returnMoves
		
func createMove(attacker, target, weapon):
	
	var distance = attacker.currentCell.mapPosition.distance_to(target.currentCell.mapPosition)
	if distance > weapon.attackRange.start and distance <= weapon.attackRange.end:
		var missChance = 1 - ((attacker.type.agility / (attacker.type.agility + target.type.agility)) * 2) + ((target.type.agility / (attacker.type.agility + target.type.agility)) / 2) + weapon.miss
		if missChance < 0:
			missChance = 0
		elif missChance > 1:
			missChance = 1
		
		return {
			"attacker": attacker,
			"target": target,
			"miss": missChance if missChance >= 0 else 0,
			"crit": attacker.type.crit + weapon.crit,
			"damage": weapon.damage
		}