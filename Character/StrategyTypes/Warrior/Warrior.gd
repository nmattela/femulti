extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Warrior"):
	maxMovement = 5
	maxHealth = 18
	agility = 0.4
	strength = 0.8
	crit = 0.12
	
	description = "Massive strength but low agility and movement"
	
	goodAttack = ["Axe", "Tomahawk"]
	badAttack = ["Lance", "Bow", "Longbow"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Lance", "DarkMagic"]
	badProtection = ["Sword", "Axe"]