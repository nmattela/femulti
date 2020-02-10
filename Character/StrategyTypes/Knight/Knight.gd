extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Knight"):
	maxMovement = 4
	maxHealth = 25
	agility = 0.3
	strength = 0.5
	crit = 0.03
	
	description = "High health and protection, but low damage output"
	
	goodAttack = ["Lance", "Axe"]
	badAttack = ["Sword", "Tomahawk", "Bow", "Longbow"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Axe", "Sword", "Tomahawk", "Bow", "Longbow"]
	badProtection = ["LightMagic", "DarkMagic"]