extends "res://Item/Weapons/Weapon.gd"

func _init().("LightMagic"):
	targetRange = {
		"start": 0,
		"end": 2
	}
	damage = 2
	heal = 2
	crit = 0.04
	miss = 0.15
	
	description = "Low damage output but heals the user"
	
func get_type():
	return "LightMagic"
	
func is_type(type):
	return type == "LightMagic" or .is_type(type)