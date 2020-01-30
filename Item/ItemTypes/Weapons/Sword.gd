extends "res://Item/ItemTypes/Weapons/Weapon.gd"

func _init():
	texture = load("res://Item/ItemTypes/Weapons/Sword.png")
	attackRange = {
		"start": 1,
		"end": 2
	}
	damage = 3
	crit = 0.05
	miss = 0.08

func get_type():
	return "Sword"
	
func is_type(type):
	return type == "Sword" or .is_type(type)