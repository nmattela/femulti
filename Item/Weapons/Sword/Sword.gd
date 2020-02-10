extends "res://Item/Weapons/Weapon.gd"

func _init().("Sword"):
	targetRange = {
		"start": 0,
		"end": 1
	}
	damage = 3
	crit = 0.1
	miss = 0.1
	
	description = "Below average damage with high crit chance"

func get_type():
	return "Sword"
	
func is_type(type):
	return type == "Sword" or .is_type(type)