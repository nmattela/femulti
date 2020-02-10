extends VBoxContainer

var inventory

var buttons = {}

func _ready():
	show()
	
func init(i, config):
	inventory = i
	if inventory.items.size() > 0:
		for item in inventory.items:
			createButton(item, config)
	else:
		inventoryEmptyAlert()
	inventory.connect("itemAdded", self, "onItemAdded")
	inventory.connect("itemRemoved", self, "onItemRemoved")
	
func inventoryEmptyAlert():
	var label = Label.new()
	label.text = "Inventory Empty!"
	add_child(label)
	
func createButton(item, config):
	var button = Button.new()
	var label  = Label.new()
	label.text = item.get_type()
	button.name = item.get_type()
	button.connect("pressed", config.context, "onPressed", [item])
	button.connect("focus_entered", config.context, "onFocusEntered", [item])
	add_child(button)
	button.add_child(label)
	buttons[item] = button

func show():
	focus()
	.show()
	
func hide():
	.hide()
	
func focus():
	if inventory.items.size() > 0:
		buttons[inventory.items[0]].grab_focus()
	
func onItemAdded(item):
	pass
	
func onItemRemoved(item):
	var button = buttons[item]
	remove_child(button)
	button.queue_free()
	buttons[inventory.items[0]].grab_focus()