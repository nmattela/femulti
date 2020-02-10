extends "res://Item/Staffs/Staff.gd"

func _init().("Healing"):
	targetRange = {
		"start": 0,
		"end": 1
	}
	heal = 5
	
	description = "Heals HP to allies and the character itself (if skilled enough)"