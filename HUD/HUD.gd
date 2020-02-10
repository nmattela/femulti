extends CanvasLayer

var BattleMenu = load("res://HUD/BattleMenu/Menu.tscn")
var CharacterStats = load("res://HUD/CharacterStats/CharacterStats.tscn")
var Inventory = load("res://HUD/Inventory/Inventory.tscn")

func _ready():
	pass
	
func createBattleMenu(config):
	var battleMenu = BattleMenu.instance()
	battleMenu.init(config)
	add_child(battleMenu)
	return battleMenu
	
func createInventoryMenu(character, config):
	var inventory = Inventory.instance()
	inventory.init(character.inventory, config)
	add_child(inventory)
	return inventory
	
func createCharacterStats(left = true):
	var characterStats = CharacterStats.instance()
	add_child(characterStats)
	characterStats.init(left)
	return characterStats