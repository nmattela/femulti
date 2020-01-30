extends VBoxContainer

var firstButton

func _ready():
	show()
	
func init(config):
	for con in config.buttons:
		createButton(config.context, con)
	firstButton = get_node(config.buttons[0].text)
	
func createButton(context, config):
	var button = Button.new()
	var label = Label.new()
	label.text = config.text
	button.name = config.text
	if config.has("params"):
		button.connect("pressed", context, config.onSelect, config.params)
		button.connect("focus_entered", context, config.onFocus, config.params)
	else:
		button.connect("pressed", context, config.onSelect)
	add_child(button)
	button.add_child(label)

func show():
	firstButton.grab_focus()
	.show()
	
func hide():
	.hide()
	
func onFocusEntered(config):
	pass
