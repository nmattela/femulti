extends "res://Turn/State/State.gd"

var SelectEnemy = load("res://Turn/State/SelectEnemy.gd")
var NothingSelected = load("res://Turn/State/NothingSelected.gd")

var character
var menu

func _init(c, t, gr).(t, gr):
	character = c

func openMenu():
	if menu == null:
		menu = turn.openMenu({
			"context": self,
			"buttons": [
				{"text": "Attack", "fn": "attackPressed"},
				{"text": "Inventory", "fn": ""},
				{"text": "Wait", "fn": "waitPressed"},
				{"text": "Cancel", "fn": ""}
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
	
func standby():
	standbyState.selectorPosition = turn.position
	closeMenu()
	
func resume():
	if standbyState.selectorPosition != null:
		turn.position = standbyState.selectorPosition
	openMenu()
	#character.connect("movementFinished", self, "openMenu")
	
func destroy():
	menu.queue_free()
	.destroy()