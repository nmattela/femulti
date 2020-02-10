extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Paladin"):
	maxMovement = 10
	maxHealth = 20
	agility = 0.38
	strength = 0.3
	crit = 0.06
	
	description = "Low agility and strength but large movement range"
	
	goodAttack = ["Lance", "Sword"]
	badAttack = ["Longbow", "Axe", "Tomahawk"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Sword", "Longbow"]
	badProtection = ["Axe", "Lance", "LightMagic"]