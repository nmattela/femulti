extends Control

func _ready():
	pass
	
func setHealth(health):
	$HealthBar.value = health
	
func updateHealth(health):
	$Tween.interpolate_property($HealthBar, "value", $HealthBar.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func setMaxHealth(maxHealth):
	$HealthBar.max_value = maxHealth
	
func setPotentialHealthLoss(character, healthLoss):
	$HealthBarBehind.max_value = character.type.maxHealth
	$HealthBarBehind.value = character.health
	var newHealth = character.health - healthLoss
	updateHealth(newHealth if newHealth >= 0 else 0)