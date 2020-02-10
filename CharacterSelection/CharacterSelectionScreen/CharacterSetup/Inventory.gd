extends HBoxContainer

var SpriteButton = load("res://CharacterSelection/CharacterSelectionScreen/SpriteButton/SpriteButton.tscn")

var inventory

var buttons = []
var items = []

func _ready():
	pass
	
func init(i):
	inventory = i
	inventory.connect("itemAdded", self, "add")
	inventory.connect("itemRemoved", self, "remove")
	
	buttons = []
	for idx in range(inventory.maxAmount):
		var button = SpriteButton.instance()
		add_child(button)
		buttons.append(button)
		items.append(null)
	setNeighbors(buttons)
		
func setNeighbors(buttons):
	var amount = buttons.size()
	for idx in range(amount):
		var button = buttons[idx]
		var leftButton
		if idx == 0:
			leftButton = buttons[amount-1]
		else:
			leftButton = buttons[(idx-1) % amount]
		var rightButton = buttons[(idx+1) % amount]
		
		button.focus_neighbour_left = leftButton.get_path()
		button.focus_neighbour_right = rightButton.get_path()
		button.focus_neighbour_top = get_path()
		button.focus_neighbour_bottom = get_path()
		
		button.focus_next = get_path()
		button.focus_previous = get_path()
	
func add(item):
	var uninitializedButton
	for idx in range(buttons.size()):
		if not buttons[idx].initialized:
			uninitializedButton = buttons[idx]
			items[idx] = item
			break
	uninitializedButton.init(item)
	uninitializedButton.connect("pressed", inventory, "removeItem", [item])
	
func remove(item):
	var idx = items.find(item)
	items[idx] = null
	buttons[idx].clear()
	buttons[idx].disconnect("pressed", inventory, "removeItem")
	
func clear():
	for idx in range(buttons.size()):
		remove(items[idx])
		remove_child(buttons[idx])
		
		
func focus():
	if get_children().size() > 0:
		get_child(0).grab_focus()