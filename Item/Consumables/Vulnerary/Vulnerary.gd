extends "res://Item/Consumables/Consumable.gd"

func _init().("Vulnerary"):
	description = "Heals 10HP when consumed"

func get_type():
	return "Vulnerary"
	
func is_type(type):
	return type == "Vulnerary" or .is_type(type)
	
func consume(character):
	character.updateHealth(5)