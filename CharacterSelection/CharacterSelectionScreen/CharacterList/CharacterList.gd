extends VBoxContainer

var SpriteButton = load("res://CharacterSelection/CharacterSelectionScreen/SpriteButton/SpriteButton.tscn")

var team

var buttons = []

func _ready():
	pass

func init(t):
	team = t
	
	for idx in range(team.characters.size()):
		var button = SpriteButton.instance()
		add_child(button)
		button.connect("pressed", get_parent().get_parent(), "onSlotSelected", [button, idx])
		buttons.append(button)
	setNeighbors()
	
func disable():
	for button in buttons:
		button.disabled = true
		
func enable():
	for button in buttons:
		button.disabled = false
	
func setNeighbors():
	var amount = team.characters.size()
	for idx in range(amount):
		var child = get_child(idx)
		var nextChild = get_child((idx+1) % amount)
		var prevChild
		if idx == 0:
			prevChild = get_child(amount-1)
		else:
			prevChild = get_child((idx-1) % amount)
		
		child.set_focus_neighbour(MARGIN_BOTTOM, nextChild.get_path())
		child.set_focus_neighbour(MARGIN_TOP, prevChild.get_path())
		child.set_focus_neighbour(MARGIN_RIGHT, child.get_path())
		child.set_focus_neighbour(MARGIN_LEFT, child.get_path())
		
		child.focus_next = child.get_path()
		child.focus_previous = child.get_path()
	
func focus():
	if visible:
		get_child(0).grab_focus()
		get_parent().get_parent().get_parent().get_parent().setButtonInfos([
			{"button": "A", "text": "Select Slot"},
			{"button": "X", "text": "Confirm"}
		])