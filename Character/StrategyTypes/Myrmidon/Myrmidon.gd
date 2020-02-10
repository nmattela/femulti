extends "res://Character/StrategyTypes/StrategyType.gd"

func _init(teamNo).(teamNo, "Myrmidon"):
	maxMovement = 7
	maxHealth = 15
	agility = 0.70
	strength = 0.6
	crit = 0.09
	
	description = "Very agile and moderate strength"
	
	goodAttack = ["Sword", "LightMagic"]
	badAttack = ["Axe", "Longbow", "Tomahawk"]
	
	goodAssist = []
	badAssist = ["Healing"]
	
	goodProtection = ["Axe", "Bow"]
	badProtection = ["Lance", "DarkMagic"]