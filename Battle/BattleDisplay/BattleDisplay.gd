extends Control

signal finished
signal done
signal notification

var attack
var character
var left

var initialPos

func _ready():
	pass
	
func init(at, c, l):
	attack = at
	character = c
	left = l
	
	$Sprite.texture = character.get_node("Sprite").texture
	initialPos = $Sprite.position
	
	if attack:
		var weapon = character.inventory.getSelectedWeapon()
		
		$SelectedItem.text = weapon.get_type() if weapon != null else "No Weapon!"
	else:
		var staff = character.inventory.getSelectedStaff()
		$SelectedItem.text = staff.get_type() if staff != null else "No Staff!"
		
	$HealthBar.init(character)
	
func engage(move, delta):
	var initDir = 1 if left else -1
	var targetDir = Vector2(initDir, 0) if not move.returning else Vector2(-initDir, 0)
	var targetPos = initialPos + Vector2(initDir * 100, 0) if not move.returning else initialPos
	
	var velocity = 100 * targetDir * delta

	var distanceToTarget = Vector2(abs(targetPos.x - $Sprite.position.x), abs(targetPos.y - $Sprite.position.y))
	if abs(velocity.x) > distanceToTarget.x:
		velocity.x = distanceToTarget.x * targetDir.x
		
		if not move.returning:
			move.returning = true
			
			if attack:
				var damage = 0
				if not move.miss and not move.crit:
					emit_signal("notification", "Hit!")
					damage = -move.damage
				elif not move.miss and move.crit:
					emit_signal("notification", "Critical!")
					damage = -move.damage * 2
				elif move.miss:
					emit_signal("notification", "Miss!")
					
				if not move.miss:
					move.ally.updateHealth(move.heal)
					move.target.updateHealth(damage)
			else:
				move.ally.updateHealth(move.allyHeal)
				move.target.updateHealth(move.targetHeal)
		elif move.target.dead:
			emit_signal("finished")
		else:
			emit_signal("done")
		
	$Sprite.position += velocity