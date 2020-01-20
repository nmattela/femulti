extends "res://Selector/SelectorState.gd"

var CharacterSelect = load("res://Selector/CharacterSelect.gd")

func _init(gr, sel).(gr, sel):
	pass

func spaceBarPressed(position):
	var cell = selector.grid.getCell(position)
	if cell.content != null and cell.content.type == "character" and cell.content.movable:
		emit_signal("stateChanged", CharacterSelect.new(cell, grid, selector))