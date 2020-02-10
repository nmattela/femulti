extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Mage"):
	maxMovement = 6
	maxHealth = 14
	agility = 0.54
	strength = 0.6
	crit = 0.1
	
	description = "Good at using dark magic, but low chance for critical hits"
	
	goodAttack = ["DarkMagic"]
	badAttack = ["Axe", "Bow", "Longbow", "Lance", "Tomahawk", "Axe"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Axe", "Bow", "Longbow", "DarkMagic"]
	badProtection = ["Lance", "LightMagic"]