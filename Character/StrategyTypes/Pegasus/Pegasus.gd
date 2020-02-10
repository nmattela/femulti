extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Pegasus"):
	maxMovement = 15
	maxHealth = 13
	agility = 0.8
	strength = 0.3
	crit = 0.17
	
	description = "Very large movement range but very vulnerable"
	
	goodAttack = ["Axe", "Bow"]
	badAttack = ["Tomahawk", "Longbow", "Lance"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["LightMagic", "DarkMagic"]
	badProtection = ["Bow", "Longbow"]