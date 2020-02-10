extends MarginContainer

var character
var attack

func _ready():
	pass
	
	
func init(left = true):
	if left:
		rect_position = Vector2(128, 0)
	else:
		rect_position = Vector2(1280 - (rect_size.x * rect_scale.x) - 128, 0)
		
func setCharacter(a, c):
	character = c
	attack = a
	displayStats()
	character.connect("healthUpdated", self, "displayStats")
	
func listenForAnimationFinished(context, callback):
	$VBoxContainer/HealthBar.listenForAnimationFinished(context, callback)
		
func displayStats():
	$VBoxContainer/CharacterSprite.texture = character.type.texture
	$VBoxContainer/CharacterName.text = character.type.type
	$VBoxContainer/HealthBar.init(character)
	if attack:
		var selectedWeapon = character.inventory.getSelectedWeapon()
		$VBoxContainer/SelectedWeapon.text = selectedWeapon.get_type() if selectedWeapon != null else "No weapons!"
	else:
		var selectedStaff = character.inventory.getSelectedStaff()
		$VBoxContainer/SelectedWeapon.text = selectedStaff.get_type() if selectedStaff != null else "No staffs!"
	
func displayForecast(stats):
	if attack:
		$VBoxContainer/HealthBar.setPotentialHealthLoss(character, stats.damage - stats.heal)
		$VBoxContainer/MissChance.text = "Miss: {m}%".format({"m": round(stats.missChance * 100)})
		$VBoxContainer/CritChance.text = "Crit: {c}%".format({"c": round(stats.critChance * 100)})
	else:
		$VBoxContainer/HealthBar.setPotentialHealthLoss(character, -stats.heal)