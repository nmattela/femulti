extends "res://Turn/State/State.gd"

var AttackArea = load("res://Misc/AttackArea.gd")
var SelectWeapon = load("res://Turn/State/SelectWeapon.gd")

var attackArea
var character

var enemies
var enemyIndex = -1

var allyCharacterStats
var enemyCharacterStats

func _init(c, t, gr).(t, gr):
	character = c
	attackArea = AttackArea.new(grid, character)
	enemies = attackArea.getEnemies()
	movement.maxTimeout = 5
	
	allyCharacterStats = turn.team.hud.createCharacterStats(true)
	enemyCharacterStats = turn.team.hud.createCharacterStats(false)
	
	allyCharacterStats.displayStats(character)
	
func move(delta, direction):
	if direction != Vector2(0, 0) and enemies.size() > 0:
		if movement.timeout == 0:
			movement.timeout = movement.maxTimeout
			enemyIndex = int(enemyIndex + direction.x) % enemies.size()
			turn.position = enemies[enemyIndex].position
			
			enemyCharacterStats.displayStats(enemies[enemyIndex])
		else:
			movement.timeout -= 1
	elif movement.timeout > 0:
		movement.timeout -= 1
		
func spaceBarPressed():
	if enemyIndex >= 0:
		emit_signal("stateChanged", SelectWeapon.new(enemies[enemyIndex], character, turn, grid))
	
func standby():
	attackArea.clearAttackArea()
	allyCharacterStats.hide()
	enemyCharacterStats.hide()
	
func resume():
	attackArea.displayAttackArea()
	allyCharacterStats.show()
	enemyCharacterStats.show()
	move(0, Vector2(1, 0))
	
func destroy():
	attackArea.clearAttackArea()
	allyCharacterStats.queue_free()
	enemyCharacterStats.queue_free()
	.destroy()