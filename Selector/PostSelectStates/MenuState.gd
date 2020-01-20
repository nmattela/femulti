extends "res://Selector/PostSelectStates/State.gd"

var AttackState = load("res://Selector/PostSelectStates/AttackState.gd")

var character
var selector

var menu

func _init(ch, sel):
	character = ch
	selector = sel
	character.connect("movementFinished", self, "openMenu")
	
func openMenu():
	menu = selector.openMenu({
		"context": self,
		"buttons": [
			{"text": "Attack", "fn": "attackPressed"},
			{"text": "Inventory", "fn": ""},
			{"text": "Wait", "fn": "waitPressed"},
			{"text": "Cancel", "fn": ""}
		]
	})
	
func attackPressed():
	menu.queue_free()
	emit_signal("stateChanged", AttackState.new(selector.grid, selector.grid.getCell(character.position)))
	
func waitPressed():
	menu.queue_free()
	emit_signal("done")