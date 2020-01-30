extends CanvasLayer

onready var HealthBar = preload("res://HUD/HealthBar/HealthBar.tscn")

signal battleFinished

var ally
var enemy

var moves = []

func _ready():
	pass

func init(a, e):
	ally = a
	enemy = e
	
	$AllySprite.texture = ally.get_node("Sprite").texture
	$EnemySprite.texture = enemy.get_node("Sprite").texture
	
	$AllySelectedWeapon.text = ally.inventory.getSelectedWeapon().get_type()
	$EnemySelectedWeapon.text = enemy.inventory.getSelectedWeapon().get_type()
	
	$AllyHealthBar.setMaxHealth(ally.type.maxHealth)
	$AllyHealthBar.setHealth(ally.health)
	$EnemyHealthBar.setMaxHealth(enemy.type.maxHealth)
	$EnemyHealthBar.setHealth(enemy.health)
	
	var attackMoves = ally.calculateAttack(enemy, ally.inventory.getSelectedWeapon())
	
	for attackMove in attackMoves:
		addMove(attackMove)
	
func addMove(attackMove):
	moves.append({
		"attacker": attackMove.attacker,
		"target": attackMove.target,
		"returning": false,
		"sprite": $AllySprite if attackMove.attacker == ally else $EnemySprite,
		"enemyHealthBar": $EnemyHealthBar if attackMove.attacker == ally else $AllyHealthBar,
		"initialPos": $AllySprite.position if attackMove.attacker == ally else $EnemySprite.position,
		"endPos": $AllySprite.position + Vector2(100, 0) if attackMove.attacker == ally else $EnemySprite.position + Vector2(-100, 0),
		"miss": randf() < attackMove.miss,
		"crit": randf() < attackMove.crit,
		"damage": attackMove.damage
	})
	
func finish():
	emit_signal("battleFinished")
	queue_free()
	
func _process(delta):
	if moves.size() > 0:
		var move = moves[0]
		var targetDir = Vector2(1, 0) if (move.attacker == ally and not move.returning) or (move.attacker == enemy and move.returning) else Vector2(-1, 0)
		var targetPos = move.endPos if not move.returning else move.initialPos
		
		var velocity = 100 * targetDir * delta
	
		var distanceToTarget = Vector2(abs(targetPos.x - move.sprite.position.x), abs(targetPos.y - move.sprite.position.y))
		if abs(velocity.x) > distanceToTarget.x:
			velocity.x = distanceToTarget.x * targetDir.x
			
			if not move.returning:
				move.returning = true
				if not move.miss and not move.crit:
					$Notification.text = "Hit!"
					move.target.health -= move.damage
				elif not move.miss and move.crit:
					$Notification.text = "Critical!"
					move.target.health -= move.damage * 2
				elif move.miss:
					$Notification.text = "Miss!"
				move.enemyHealthBar.updateHealth(move.target.health)
				if move.target.health <= 0:
					move.target.die()
			elif move.target.dead:
				finish()
			else:
				moves.pop_front()
			
		move.sprite.position += velocity
		
		if moves.size() == 0:
			finish()
	
	
	
	
	
	
	
	
	
#	if state > 0 and state < 5:
#		var targetDir = Vector2(1, 0) if state == 1 or state == 4 else Vector2(-1, 0)
#		var targetSprite = $AllySprite if state == 1 or state == 2 else $EnemySprite
#		var targetPos
#		if state == 1:
#			targetPos = movement.allyTargetPos
#		elif state == 2:
#			targetPos = movement.allyInitialPos
#		elif state == 3:
#			targetPos = movement.enemyTargetPos
#		elif state == 4:
#			targetPos = movement.enemyInitialPos
#
#		var velocity = movement.speed * targetDir * delta
#
#		var distanceToTarget = Vector2(abs(targetPos.x - targetSprite.position.x), abs(targetPos.y - targetSprite.position.y))
#		if abs(velocity.x) > distanceToTarget.x:
#			velocity.x = distanceToTarget.x * targetDir.x
#			state += 1
#			if state == 2:
#				enemy.health -= ally.inventory.getSelectedWeapon().damage
#				$EnemyHealthBar.setHealth(enemy.health)
#				if enemy.health <= 0:
#					enemy.die()
#			elif state == 4:
#				ally.health  -= enemy.inventory.getSelectedWeapon().damage
#				$AllyHealthBar.setHealth(ally.health)
#				if ally.health <= 0:
#					ally.die()
#
#
#		targetSprite.position += velocity
#	elif state == 5:
#		emit_signal("battleFinished")
#		queue_free()