extends Object

var type
var supertype

var texture

var description = "No Description"

func _init(st, t):
	type = t
	supertype = st
	texture = load("res://Item/{st}/{t}/{t}.png".format({
		"st": supertype,
		"t": type
	}))

func get_type():
	return "Item"
	
func is_type(type):
	return type == "Item"

var itemType