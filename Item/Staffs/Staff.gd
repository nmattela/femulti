extends "res://Item/Item.gd"

var targetRange = {
	"start": 0,
	"end": 0
}

var heal = 0

func _init(t).("Staffs", t):
	pass
	
func get_type():
	return "Staff"
	
func is_type(type):
	return type == "Staff" or .is_type(type)
