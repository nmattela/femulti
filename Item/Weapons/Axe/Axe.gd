extends "res://Item/Weapons/Weapon.gd"

func _init().("Axe"):
	targetRange = {
		"start": 0,
		"end": 1
	}
	damage = 5
	crit = 0.03
	miss = 0.13
	
	description = "Large damage output but high miss chance"
	
func get_type():
	return "Axe"
	
func is_type(type):
	return type == "Axe" or .is_type(type)