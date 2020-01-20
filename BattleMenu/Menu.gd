extends Node2D

signal buttonPressed

var firstButton

func _ready():
	show()
	
func init(pos, config):
	position = pos
	for con in config.buttons:
		createButton(config.context, con)
	firstButton = $Menu.get_node(config.buttons[0].text)
	
func createButton(context, config):
	var button = Button.new()
	var label = Label.new()
	label.text = config.text
	button.name = config.text
	if config.has("params"):
		button.connect("pressed", context, config.fn, config.params)
	else:
		button.connect("pressed", context, config.fn)
	$Menu.add_child(button)
	button.add_child(label)

func show():
	firstButton.grab_focus()
	.show()
	
func buttonPressed():
	pass