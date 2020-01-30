extends MarginContainer

var character

func _ready():
	pass
	
	
func init(left = true):
	if left:
		rect_position = Vector2(128, 0)
	else:
		rect_position = Vector2(1920 - (rect_size.x * rect_scale.x) - 128, 0)
		
func displayStats(c):
	character = c
	$VBoxContainer/CharacterSprite.texture = character.type.texture
	$VBoxContainer/CharacterName.text = character.type.type
	$VBoxContainer/HealthBar.setMaxHealth(character.type.maxHealth)
	$VBoxContainer/HealthBar.setHealth(character.health)
	$VBoxContainer/SelectedWeapon.text = character.inventory.getSelectedWeapon().get_type()
	
func displayForecast(stats):
	$VBoxContainer/HealthBar.setPotentialHealthLoss(character, stats.damage)
	$VBoxContainer/MissChance.text = "Miss: {m}%".format({"m": round(stats.missChance * 100)})
	$VBoxContainer/CritChance.text = "Crit: {c}%".format({"c": round(stats.critChance * 100)})