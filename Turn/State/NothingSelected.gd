extends "res://Turn/State/State.gd"

var CharacterSelected = load("res://Turn/State/CharacterSelected.gd")
var GeneralSelected   = load("res://Turn/State/GeneralSelected.gd")

func _init(t, gr).(t, gr):
	pass

func spaceBarPressed():
	var focussedCell = grid.world_to_cell(turn.position)
	var character = focussedCell.content
	if turn.team.isTeamMember(character) and not turn.isCharacterFinished(character):
		emit_signal("stateChanged", CharacterSelected.new(character, turn, grid))
	else:
		emit_signal("stateChanged", GeneralSelected.new(turn, grid))
		
func standby():
	standbyState.selectorPosition = turn.position
	
func resume():
	if standbyState.selectorPosition != null:
		turn.position = standbyState.selectorPosition
	turn.showSelector()
	
func destroy():
	.destroy()