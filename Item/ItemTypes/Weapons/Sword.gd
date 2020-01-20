extends "res://Item/ItemTypes/Weapons/Weapon.gd"

func _init():
	texture = load("res://Item/ItemTypes/Weapons/Sword.png")
	attackRange = {
		"start": 0,
		"end": 1
	}
	damage = 3

func get_type():
	return "Sword"
	
func is_type(type):
	return type == "Sword" or .is_type(type)