extends GridContainer

var SpriteButton = load("res://CharacterSelection/CharacterSelectionScreen/SpriteButton/SpriteButton.tscn")
	
func createButtons(items, context):
	var buttons = {}
	for item in items:
		buttons[item] = SpriteButton.instance()
		buttons[item].init(item)
		buttons[item].connect("pressed", context, "onSelect", [item])
		buttons[item].connect("focus_entered", context, "onFocusEntered", [item])
	return buttons
	
func setNeighbors(buttons):
	var amount = buttons.values().size()
	for idx in range(amount):
		var child = get_child(idx)
		
		var rightChild
		if idx+1 % 9 == 9 or idx+1 == amount:
			rightChild = get_child(idx)
		else:
			rightChild = get_child(idx+1)
			
		var leftChild
		if idx-1 % 9 == 8 or idx == 0:
			leftChild = get_child(idx)
		else:
			leftChild = get_child(idx-1)
			
		var topChild
		if idx-9 < 0:
			topChild = get_child(idx)
		else:
			topChild = get_child((idx-9) % amount)
			
		var bottomChild
		if idx+9 > amount:
			bottomChild = get_child(idx)
		else:
			bottomChild = get_child((idx+9) % amount)
		
		child.set_focus_neighbour(MARGIN_RIGHT, rightChild.get_path())
		child.set_focus_neighbour(MARGIN_LEFT, leftChild.get_path())
		child.set_focus_neighbour(MARGIN_BOTTOM, bottomChild.get_path())
		child.set_focus_neighbour(MARGIN_TOP, topChild.get_path())
		
		child.focus_next = child.get_path()
		child.focus_previous = child.get_path()
	
func fill(buttons):
	var buttonArray = buttons.values()
	for btn in buttonArray:
		add_child(btn)
	setNeighbors(buttons)
	focus()
	
func disable():
	for child in get_children():
		child.hide()
		
func enable():
	for child in get_children():
		child.show()
	
func empty(buttons):
	var buttonArray = buttons.values()
	for btn in buttonArray:
		remove_child(btn)
		
func focus():
	get_child(0).grab_focus()