extends "res://Item/Item.gd"


func _init(t).("Consumables", t):
	pass
	
func get_type():
	return "Consumable"
	
func is_type(type):
	return type == "Consumable" or .is_type(type)

func consume(character):
	pass