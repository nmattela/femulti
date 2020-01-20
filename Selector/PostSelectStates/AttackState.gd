extends "res://Selector/PostSelectStates/State.gd"

var AttackArea = load("res://Misc/AttackArea.gd")

var attackArea
var enemies = []

func _init(gr, sc):
	attackArea = AttackArea.new(gr, sc)
	
func move(delta, direction):
	var c = attackArea.attackArea[0][0]