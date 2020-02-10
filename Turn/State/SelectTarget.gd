extends "res://Turn/State/State.gd"

var TargetArea = load("res://Misc/TargetArea.gd")
var SelectItem = load("res://Turn/State/SelectItem.gd")

var area
var attack
var character

var targets
var targetIndex = -1

var allyCharacterStats
var targetCharacterStats

func _init(a, c, t, gr).(t, gr):
	attack = a
	character = c
	area = TargetArea.new(grid, character, attack)
	targets = area.getTargets()
	movement.maxTimeout = 5
	
	allyCharacterStats = turn.team.hud.createCharacterStats(true)
	targetCharacterStats = turn.team.hud.createCharacterStats(false)
	
	allyCharacterStats.setCharacter(attack, character)
	
func move(delta, direction):
	if direction != Vector2(0, 0) and targets.size() > 0:
		if movement.timeout == 0:
			movement.timeout = movement.maxTimeout
			targetIndex = int(targetIndex + direction.x) % targets.size()
			turn.position = targets[targetIndex].position
			
			targetCharacterStats.setCharacter(attack, targets[targetIndex])
		else:
			movement.timeout -= 1
	elif movement.timeout > 0:
		movement.timeout -= 1
		
func spaceBarPressed():
	if targetIndex >= 0:
		emit_signal("stateChanged", SelectItem.new(attack, targets[targetIndex], character, turn, grid))
	
func standby():
	area.clear()
	allyCharacterStats.hide()
	targetCharacterStats.hide()
	
func resume():
	area.display()
	allyCharacterStats.show()
	targetCharacterStats.show()
	move(0, Vector2(1, 0))
	
func destroy():
	area.clear()
	allyCharacterStats.queue_free()
	targetCharacterStats.queue_free()
	.destroy()