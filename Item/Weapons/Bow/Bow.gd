extends "res://Item/Weapons/Weapon.gd"

func _init().("Bow"):
	targetRange = {
		"start": 1,
		"end": 2
	}
	damage = 3
	crit = 0.08
	miss = 0.17
	
	description = "Long range distance with reasonable accuracy"
	
func get_type():
	return "Bow"
	
func is_type(type):
	return type == "Bow" or .is_type(type)