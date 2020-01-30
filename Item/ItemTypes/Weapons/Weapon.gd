extends "res://Item/ItemTypes/ItemType.gd"

var attackRange = {
	"start": 0,
	"end": 0
}

var damage = 0
var crit = 1
var miss = 1

func init():
	pass
	
func get_type():
	return "Weapon"
	
func is_type(type):
	return type == "Weapon" or .is_type(type)