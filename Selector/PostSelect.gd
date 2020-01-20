extends "res://Selector/SelectorState.gd"

var MenuState = load("res://Selector/PostSelectStates/MenuState.gd")
var NoSelect  = load("res://Selector/NoSelect.gd")

var character
var menu

var state

func _init(c, gr, sel).(gr, sel):
	character = c
	onStateChanged(MenuState.new(character, selector))
	
func onStateChanged(newState):
	state = newState
	state.connect("stateChanged", self, "onStateChanged")
	state.connect("done", self, "onDone")
	
func animateMovement(delta):
	state.move(delta, selector.direction)
	
func onDone():
	character.indicateUnmovable()
	emit_signal("stateChanged", NoSelect.new(grid, selector))