extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Archer"):
	maxMovement = 7
	maxHealth = 12
	agility = 0.8
	strength = 0.3
	crit = 0.11
	
	description = "Good at using bows and very agile, but weak in strength"
	
	goodAttack = ["Bow", "Longbow"]
	badAttack = ["Lance", "Sword", "Axe"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Lance", "LightMagic"]
	badProtection = ["Sword", "DarkMagic"]