extends "res://CharacterSelection/CharacterSelectionScreen/CharacterSetup/States/State.gd"

var SelectItems = load("res://CharacterSelection/CharacterSelectionScreen/CharacterSetup/States/SelectItems.gd")

var characters = []

var gridButtons = []

func _init(s, gr, d).(s, gr, d):	
	var chars = readDir("res://Character/StrategyTypes")
	
	for character in chars:
		characters.append(character.new(setup.get_parent().get_parent().get_parent().team.teamNumber))
		
	gridButtons = grid.createButtons(characters, self)
	
func focusToSelection():
	buttonInfos = [
		{"button": "A", "text": "Select Character"},
		{"button": "X", "text": "Confirm"}
	]
	.focusToSelection()
	
func resume():
	grid.fill(gridButtons)
	emit_signal("characterSelected", null)
	
func standby():
	grid.empty(gridButtons)
	
func destroy():
	grid.empty(gridButtons)
	emit_signal("characterSelected", null)
	for gridButton in gridButtons:
		gridButton.call_deferred("free")
	.destroy()
	
func onSelect(characterType):
	emit_signal("characterSelected", characterType)
	emit_signal("stateChanged", SelectItems.new(setup, grid, details))
	
func onFocusEntered(characterType):
	details.setDescription(characterType)