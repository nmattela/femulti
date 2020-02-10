extends "res://Item/Weapons/Weapon.gd"

func _init().("Tomahawk"):
	targetRange = {
		"start": 0,
		"end": 2
	}
	damage = 3
	crit = 0.07
	miss = 0.17
	
	description = "Short and long range attack with high chance for crits and for missing"
	
func get_type():
	return "Tomahawk"
	
func is_type(type):
	return type == "Tomahawk" or .is_type(type)