extends Control

var character

func _ready():
	pass
	
func init(c):
	character = c
	setMaxHealth(character.type.maxHealth)
	setHealth(character.health)
	character.connect("healthUpdated", self, "updateHealth")
	
func listenForAnimationFinished(context, callback):
	print("Listening to tween")
	$Tween.connect("tween_all_completed", context, callback)
	
func setHealth(health):
	$HealthBar.value = health
	
func setMaxHealth(maxHealth):
	$HealthBar.max_value = maxHealth
	
func updateHealth(health):
	$Tween.interpolate_property($HealthBar, "value", $HealthBar.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func setPotentialHealthLoss(character, healthLoss):
	$HealthBarBehind.max_value = character.type.maxHealth
	$HealthBarBehind.value = character.health
	var newHealth = character.health - healthLoss
	if newHealth < 0:
		newHealth = 0
	elif newHealth > character.type.maxHealth:
		newHealth = character.type.maxHealth
	updateHealth(newHealth if newHealth >= 0 else 0)