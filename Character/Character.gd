extends KinematicBody2D

signal movementFinished
signal healthUpdated
signal died
signal idled
signal mobilityChanged

onready var Inventory    = load("res://Character/Inventory.gd")
onready var Sword        = load("res://Item/Weapons/Sword.gd")
onready var Longbow      = load("res://Item/Weapons/Longbow.gd")
onready var Vulnerary    = load("res://Item/Consumables/Vulnerary.gd")

var grid
var initialCell

var type
var inventory
var characterNumber
var currentCell
var team

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
	
	
func init(gr, cn, t, strategyType, i):
	grid = gr
	characterNumber = cn
	team = t
	type = strategyType
	inventory = i
	
	health = type.maxHealth
	$Sprite.texture = type.texture
	
	$HealthBar.init(self)
	
	var spawnPoint = grid.getSpawnPoint(team.teamNumber, characterNumber)
	place(spawnPoint)
	
func place(spawnPoint):
	print(spawnPoint)
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
	emit_signal("idled")
	
func indicateUnmovable():
	$Sprite.material.set_shader_param("mix_amount", 1)
	emit_signal("mobilityChanged", false)
	
func indicateMovable():
	$Sprite.material.set_shader_param("mix_amount", 0)
	emit_signal("mobilityChanged", true)
	
func die():
	print("Character from team {x} at {pos} died".format({"x": team.teamNumber, "pos": grid.world_to_cell(position).mapPosition}))
	dead = true
	grid.world_to_cell(position).content = null
	hide()
	emit_signal("died")

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
		
		
func calculateAssist(target, staff):
	var moves = []
	var skill = type.calculateStaffSkill(staff)
	moves.append({
		"target": {
			"heal": staff.heal * skill.target
		},
		"ally": {
			"heal": (staff.heal / 2) * skill.ally
		}
	})
	return moves
		
func calculateAttack(enemy, weapon):
	var moves = []
	var enemyWeapon = enemy.inventory.getSelectedWeapon()
	if enemy.type.agility > type.agility * 1.5:
		moves.append(enemy.createMove(self, enemyWeapon))
		moves.append(createMove(enemy, weapon))
	else:
		moves.append(createMove(enemy, weapon))
		moves.append(enemy.createMove(self, enemyWeapon))
	if enemy.type.agility > type.agility * 2:
		moves.append(enemy.createMove(self, enemyWeapon))
	elif type.agility > enemy.type.agility * 2:
		moves.append(createMove(enemy, weapon))
		
	var returnMoves = []
	for move in moves:
		if move != null:
			returnMoves.append(move)
	return returnMoves
		
func createMove(enemy, weapon):
	if weapon != null:
		var distance = currentCell.mapPosition.distance_to(enemy.currentCell.mapPosition)
		if distance > weapon.targetRange.start and distance <= weapon.targetRange.end:
			return {
				"attacker": self,
				"target": enemy,
				"miss": calculateMissChance(enemy, weapon),
				"crit": type.crit + weapon.crit,
				"damage": calculateDamage(enemy, weapon),
				"heal": weapon.heal
			}
			
func calculateMissChance(enemy, weapon):
	var denom = type.agility + enemy.type.agility
	var missChance = 1 - (type.agility + 0.2 / denom) + weapon.miss
	if missChance < 0:
		return 0
	elif missChance > 1:
		return 1
	else:
		return missChance
			
func calculateDamage(enemy, weapon):
	var attackerWeaponSkill = type.calculateWeaponSkill(weapon)
	var targetWeaponProtection = enemy.type.calculateWeaponProtection(weapon)
	
	return int(weapon.damage + weapon.damage * (attackerWeaponSkill * targetWeaponProtection))
		
func updateHealth(healthDelta):
	if health + healthDelta < 0:
		health = 0
	elif health + healthDelta > type.maxHealth:
		health = type.maxHealth
	else:
		health += healthDelta
	if health <= 0:
		die()
		
	emit_signal("healthUpdated", health)