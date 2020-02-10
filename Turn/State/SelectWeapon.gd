extends "res://Turn/State/State.gd"

var Battle = load("res://Battle/Battle.tscn")

var enemy
var character
var menu
var weapons

var allyCharacterStats
var enemyCharacterStats

func _init(e, c, t, gr).(t, gr):
	enemy = e
	character = c
	weapons = character.inventory.getWeapons()
	
	allyCharacterStats = turn.team.hud.createCharacterStats(true)
	enemyCharacterStats = turn.team.hud.createCharacterStats(false)
	
	allyCharacterStats.setCharacter(character)
	enemyCharacterStats.setCharacter(enemy)
	
func move(delta, direction):
	pass

func openMenu():
	if menu == null:
		var weaponButtons = []
		for weapon in weapons:
			var distance = grid.world_to_map(character.position).distance_to(grid.world_to_map(enemy.position))
			if distance > weapon.targetRange.start and distance <= weapon.targetRange.end:
				weaponButtons.append({
					"text": weapon.get_type(),
					"onSelect": "beginBattle",
					"onFocus": "displayForecast",
					"params": [weapon]
				})
		
		menu = turn.createMenu({
			"context": self,
			"buttons": weaponButtons
		})
	else:
		menu.show()
		
func closeMenu():
	menu.hide()
		
func standby():
	allyCharacterStats.hide()
	enemyCharacterStats.hide()
	closeMenu()
	
func resume():
	allyCharacterStats.show()
	enemyCharacterStats.show()
	openMenu()
	
func spaceBarPressed():
	pass
	
func displayForecast(selectedWeapon):
	
	var attackMoves = character.calculateAttack(enemy, selectedWeapon)
	
	var ally = {
		"damage": 0,
		"heal": 0,
		"missChance": 0,
		"critChance": 0
	}
	var enemy = {
		"damage": 0,
		"heal": 0,
		"missChance": 0,
		"critChance": 0
	}

	for attackMove in attackMoves:
		if attackMove.attacker == character:
			enemy.damage += attackMove.damage
			ally.heal += attackMove.heal
			ally.missChance = attackMove.miss
			ally.critChance = attackMove.crit
		else:
			ally.damage += attackMove.damage
			enemy.heal += attackMove.heal
			enemy.missChance = attackMove.miss
			enemy.critChance = attackMove.crit
	
	allyCharacterStats.displayForecast(ally)
	enemyCharacterStats.displayForecast(enemy)
	
func beginBattle(selectedWeapon):
	standby()
	character.inventory.selectedWeapon = selectedWeapon
	var battle = Battle.instance()
	turn.add_child(battle)
	battle.connect("battleFinished", self, "endBattle")
	battle.init(character, enemy)
	
func endBattle():
	emit_signal("done", character)
	
func destroy():
	menu.queue_free()
	allyCharacterStats.queue_free()
	enemyCharacterStats.queue_free()
	.destroy()