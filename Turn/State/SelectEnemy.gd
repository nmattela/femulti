extends "res://Turn/State/State.gd"

var TargetArea = load("res://Misc/TargetArea.gd")
var SelectWeapon = load("res://Turn/State/SelectWeapon.gd")

var area
var character

var enemies
var enemyIndex = -1

var allyCharacterStats
var enemyCharacterStats

func _init(c, t, gr).(t, gr):
	character = c
	area = TargetArea.new(grid, character, true)
	enemies = area.getTargets()
	movement.maxTimeout = 5
	
	allyCharacterStats = turn.team.hud.createCharacterStats(true)
	enemyCharacterStats = turn.team.hud.createCharacterStats(false)
	
	allyCharacterStats.setCharacter(character)
	
func move(delta, direction):
	if direction != Vector2(0, 0) and enemies.size() > 0:
		if movement.timeout == 0:
			movement.timeout = movement.maxTimeout
			enemyIndex = int(enemyIndex + direction.x) % enemies.size()
			turn.position = enemies[enemyIndex].position
			
			enemyCharacterStats.setCharacter(enemies[enemyIndex])
		else:
			movement.timeout -= 1
	elif movement.timeout > 0:
		movement.timeout -= 1
		
func spaceBarPressed():
	if enemyIndex >= 0:
		emit_signal("stateChanged", SelectWeapon.new(enemies[enemyIndex], character, turn, grid))
	
func standby():
	area.clear()
	allyCharacterStats.hide()
	enemyCharacterStats.hide()
	
func resume():
	area.display()
	allyCharacterStats.show()
	enemyCharacterStats.show()
	move(0, Vector2(1, 0))
	
func destroy():
	area.clear()
	area.call_deferred("free")
	allyCharacterStats.queue_free()
	enemyCharacterStats.queue_free()
	.destroy()