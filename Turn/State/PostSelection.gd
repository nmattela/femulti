extends "res://Turn/State/State.gd"

var SelectEnemy = load("res://Turn/State/SelectEnemy.gd")
var NothingSelected = load("res://Turn/State/NothingSelected.gd")

var character
var menu

func _init(c, t, gr).(t, gr):
	character = c

func openMenu():
	if menu == null:
		menu = turn.createMenu({
			"context": self,
			"buttons": [
				{"text": "Attack", "onSelect": "attackPressed"},
				{"text": "Inventory", "onSelect": ""},
				{"text": "Wait", "onSelect": "waitPressed"},
				{"text": "Cancel", "onSelect": "cancelPressed"}
			]
		})
	else:
		menu.show()
		
func move(delta, direction):
	pass
	
func closeMenu():
	menu.hide()
	
func attackPressed():
	emit_signal("stateChanged", SelectEnemy.new(character, turn, grid))
	
func waitPressed():
	emit_signal("done", character)
	
func cancelPressed():
	emit_signal("stateReturned")
	
func standby():
	standbyState.selectorPosition = turn.position
	closeMenu()
	
func resume():
	if standbyState.selectorPosition != null:
		turn.position = standbyState.selectorPosition
	openMenu()
	
func destroy():
	menu.queue_free()
	.destroy()