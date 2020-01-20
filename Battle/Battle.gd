extends CanvasLayer

onready var HealthBar = preload("res://Battle/HealthBar/HealthBar.tscn")

signal battleFinished

var ally
var enemy

var state = 0

var movement = {
	"allyInitialPos":  Vector2(0, 0),
	"allyTargetPos":   Vector2(0, 0),
	"enemyInitialPos": Vector2(0, 0),
	"enemyTargetPos":  Vector2(0, 0),
	
	"speed": 100
}

func _ready():
	pass

func init(a, e):
	ally = a
	enemy = e
	
	$AllySprite.texture = ally.get_node("Sprite").texture
	$EnemySprite.texture = enemy.get_node("Sprite").texture
	
	$AllyHealthBar.setMaxHealth(ally.type.maxHealth)
	$AllyHealthBar.setHealth(ally.health)
	$EnemyHealthBar.setMaxHealth(enemy.type.maxHealth)
	$EnemyHealthBar.setHealth(enemy.health)
	
	movement.allyInitialPos  = $AllySprite.position
	movement.allyTargetPos   = $AllySprite.position + Vector2(100, 0)
	movement.enemyInitialPos = $EnemySprite.position
	movement.enemyTargetPos  = $EnemySprite.position + Vector2(-100, 0)
	
	state = 1
	
func _process(delta):
	if state > 0 and state < 5:
		var targetDir = Vector2(1, 0) if state == 1 or state == 4 else Vector2(-1, 0)
		var targetSprite = $AllySprite if state == 1 or state == 2 else $EnemySprite
		var targetPos
		if state == 1:
			targetPos = movement.allyTargetPos
		elif state == 2:
			targetPos = movement.allyInitialPos
		elif state == 3:
			targetPos = movement.enemyTargetPos
		elif state == 4:
			targetPos = movement.enemyInitialPos
		
		var velocity = movement.speed * targetDir * delta
		
		var distanceToTarget = Vector2(abs(targetPos.x - targetSprite.position.x), abs(targetPos.y - targetSprite.position.y))
		if abs(velocity.x) > distanceToTarget.x:
			velocity.x = distanceToTarget.x * targetDir.x
			state += 1
			if state == 2:
				enemy.health -= ally.inventory.getSelectedWeapon().damage
				$EnemyHealthBar.setHealth(enemy.health)
				if enemy.health <= 0:
					enemy.die()
			elif state == 4:
				ally.health  -= enemy.inventory.getSelectedWeapon().damage
				$AllyHealthBar.setHealth(ally.health)
				if ally.health <= 0:
					ally.die()
			
		
		targetSprite.position += velocity
	elif state == 5:
		emit_signal("battleFinished")
		queue_free()