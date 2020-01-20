extends "res://Turn/State/State.gd"

var Battle = load("res://Battle/Battle.tscn")

var enemy
var character
var menu
var weapons

func _init(e, c, t, gr).(t, gr):
	enemy = e
	character = c
	weapons = character.inventory.getWeapons()
	
func move(delta, direction):
	pass

func openMenu():
	if menu == null:
		var weaponButtons = []
		for weapon in weapons:
			weaponButtons.append({
				"text": weapon.get_type(),
				"fn": "beginBattle",
				"params": [weapon]
			})
		
		menu = turn.openMenu({
			"context": self,
			"buttons": weaponButtons
		})
	else:
		menu.show()
		
func closeMenu():
	menu.hide()
		
func standby():
	closeMenu()
	
func resume():
	openMenu()
	
func beginBattle(selectedWeapon):
	character.inventory.selectedWeapon = selectedWeapon
	var battle = Battle.instance()
	turn.add_child(battle)
	battle.connect("battleFinished", self, "endBattle")
	battle.init(character, enemy)
	
func endBattle():
	emit_signal("done", character)
	
func destroy():
	menu.queue_free()
	.destroy()