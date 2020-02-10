extends "res://Item/Weapons/Weapon.gd"

func _init().("Longbow"):
	targetRange = {
		"start": 1,
		"end": 3
	}
	damage = 2
	crit = 0.04
	miss = 0.2
	
	description = "Very long range distance with low accuracy and low damage output"

func get_type():
	return "Longbow"
	
func is_type(type):
	return type == "Longbow" or .is_type(type)
