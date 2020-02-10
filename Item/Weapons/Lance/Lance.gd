extends "res://Item/Weapons/Weapon.gd"

func _init().("Lance"):
	targetRange = {
		"start": 0,
		"end": 1
	}
	damage = 3
	crit = 0.03
	miss = 0.03
	
	description = "Below average damage with low chance of missing"
	
func get_type():
	return "Lance"
	
func is_type(type):
	return type == "Lance" or .is_type(type)