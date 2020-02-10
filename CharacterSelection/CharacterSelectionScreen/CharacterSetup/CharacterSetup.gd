extends VBoxContainer

var SelectCharacter = load("res://CharacterSelection/CharacterSelectionScreen/CharacterSetup/States/SelectCharacter.gd")

var stateHistory = []

var characterType
var inventory

func _ready():
	pass
	
func init():
	close()
	addState(SelectCharacter.new(self, $SelectionGridPanel/SelectionGrid, $CharacterDetailsPanel/CharacterDetails))
	
func disable():
	for child in get_children():
		child.disable()
		
func enable():
	for child in get_children():
		child.enable()
	
func open():
	show()
	$SelectionGridPanel/SelectionGrid.focus()
	state().focusToSelection()
	
func close():
	hide()
	
func _process(delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			returnState()
		elif Input.is_action_just_pressed("ui_focus_down"):
			$CharacterDetailsPanel/CharacterDetails.focus()
			state().focusToInventory()
		elif Input.is_action_just_pressed("ui_focus_up"):
			$SelectionGridPanel/SelectionGrid.focus()
			state().focusToSelection()
		elif Input.is_action_just_pressed("ui_x"):
			get_parent().confirmSetup()
			
func isSetUp():
	return characterType != null and inventory != null
	
func returnSetUp():
	return {
		"type": characterType,
		"inventory": inventory
	}
	
func addState(newState):
	if state() != null:
		state().standby()
	stateHistory.push_front(newState)
	state().resume()
	get_parent().get_parent().get_parent().setButtonInfos(state().buttonInfos)
	connectToStateSignals()
	
func returnState():
	if stateHistory.size() > 1:
		state().destroy()
		stateHistory.pop_front()
		state().resume()
		connectToStateSignals()
		
func connectToStateSignals():
	state().connect("stateChanged", self, "addState")
	state().connect("stateReturned", self, "returnState")
	state().connect("characterSelected", self, "onCharacterSelected")
	state().connect("buttonInfosChanged", get_parent().get_parent().get_parent(), "setButtonInfos")
		
func onDone(characterType, inventory):
	state().destroy()
	stateHistory.pop_front()
	for state in stateHistory:
		state.call_deferred("free")
	stateHistory = []
	
func onCharacterSelected(character):
	characterType = character
	$CharacterDetailsPanel/CharacterDetails/HAlign/CharacterSprite.texture = character.texture if character != null else null
	get_parent().setSlotSprite(character)
	
func state():
	return stateHistory.front()