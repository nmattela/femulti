extends "res://Turn/State/State.gd"

var menu

func _init(t, gr).(t, gr):
	pass
	
func openMenu():
	if menu == null:
		menu = turn.createMenu({
			"context": self,
			"buttons": [
				{"text": "End", "onSelect": "endPressed"},
				{"text": "Cancel", "onSelect": "cancelPressed"}
			]
		})
	else:
		menu.show()
		
func endPressed():
	emit_signal("done")
		
func cancelPressed():
	emit_signal("stateReturned")
		
func move(delta, direction):
	pass
	
func closeMenu():
	menu.hide()

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