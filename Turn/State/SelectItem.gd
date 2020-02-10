extends "res://Turn/State/State.gd"

var Battle = load("res://Battle/Battle.tscn")

var attack
var target
var ally
var menu
var items

var allyCharacterStats
var targetCharacterStats

func _init(at, ta, al, t, gr).(t, gr):
	attack = at
	target = ta
	ally = al
	items = ally.inventory.getWeapons() if attack else ally.inventory.getStaffs()
	
	allyCharacterStats = turn.team.hud.createCharacterStats(true)
	targetCharacterStats = turn.team.hud.createCharacterStats(false)
	
	allyCharacterStats.setCharacter(attack, ally)
	targetCharacterStats.setCharacter(attack, target)
	
func move(delta, direction):
	pass

func openMenu():
	if menu == null:
		var itemButtons = []
		for item in items:
			var distance = grid.world_to_map(ally.position).distance_to(grid.world_to_map(target.position))
			if distance > item.targetRange.start and distance <= item.targetRange.end:
				itemButtons.append({
					"text": item.get_type(),
					"onSelect": "beginBattle",
					"onFocus": "displayForecast",
					"params": [item]
				})
		
		menu = turn.createMenu({
			"context": self,
			"buttons": itemButtons
		})
	else:
		menu.show()
		
func closeMenu():
	menu.hide()
		
func standby():
	allyCharacterStats.hide()
	targetCharacterStats.hide()
	closeMenu()
	
func resume():
	allyCharacterStats.show()
	targetCharacterStats.show()
	openMenu()
	
func spaceBarPressed():
	pass
	
	
func displayForecast(selectedItem):
	
	if attack:
		var moves = ally.calculateAttack(target, selectedItem)
		
		var allyStats = {
			"damage": 0,
			"heal": 0,
			"missChance": 0,
			"critChance": 0
		}
		var targetStats = {
			"damage": 0,
			"heal": 0,
			"missChance": 0,
			"critChance": 0
		}
	
		for move in moves:
			if move.attacker == ally:
				targetStats.damage += move.damage
				allyStats.heal += move.heal
				allyStats.missChance = move.miss
				allyStats.critChance = move.crit
			else:
				allyStats.damage += move.damage
				targetStats.heal += move.heal
				targetStats.missChance = move.miss
				targetStats.critChance = move.crit
		
		allyCharacterStats.displayForecast(allyStats)
		targetCharacterStats.displayForecast(targetStats)
		
	else:
		var moves = ally.calculateAssist(target, selectedItem)
		
		var allyStats = {
			"heal": 0
		}
		
		var targetStats = {
			"heal": 0
		}
		
		for move in moves:
			allyStats.heal   += move.ally.heal
			targetStats.heal += move.target.heal
			
		allyCharacterStats.displayForecast(allyStats)
		targetCharacterStats.displayForecast(targetStats)
	
func beginBattle(selectedItem):
	standby()
	if attack:
		ally.inventory.selectedWeapon = selectedItem
	else:
		ally.inventory.selectedStaff = selectedItem
	var battle = Battle.instance()
	turn.add_child(battle)
	battle.connect("battleFinished", self, "endBattle")
	battle.init(attack, ally, target)
	
func endBattle():
	emit_signal("done", ally)
	
func destroy():
	menu.queue_free()
	allyCharacterStats.queue_free()
	targetCharacterStats.queue_free()
	.destroy()