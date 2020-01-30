extends "res://Item/ItemTypes/Weapons/Weapon.gd"

func _init():
	texture = load("res://Item/ItemTypes/Weapons/Sword.png")
	attackRange = {
		"start": 1,
		"end": 2
	}
	damage = 2
	crit = 0.02
	miss = 0.12

func get_type():
	return "Longbow"
	
func is_type(type):
	return type == "Longbow" or .is_type(type)
