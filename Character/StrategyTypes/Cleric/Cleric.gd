extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Cleric"):
	maxMovement = 6
	maxHealth = 10
	agility = 0.6
	strength = 0.1
	crit = 0.05
	
	description = "Good at using light magic and staffs. Weak in health and strength"
	
	goodAttack = ["LightMagic"]
	badAttack = ["Longbow", "Lance", "Sword", "Axe", "Tomahawk", "DarkMagic"]
	
	goodAssist = ["Healing"]
	badAssist = []
	
	goodProtection = ["Axe", "Bow", "LightMagic", "DarkMagic"]
	badProtection = ["Lance", "Sword"]