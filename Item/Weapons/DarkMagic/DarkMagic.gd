extends "res://Item/Weapons/Weapon.gd"

func _init().("DarkMagic"):
	targetRange = {
		"start": 0,
		"end": 2
	}
	damage = 4
	crit = 0.04
	miss = 0.22
	
	description = "Short and long range attack with reasonable damage"
	
func get_type():
	return "DarkMagic"
	
func is_type(type):
	return type == "DarkMagic" or .is_type(type)