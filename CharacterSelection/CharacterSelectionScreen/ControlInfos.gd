extends HBoxContainer

func _ready():
	pass
	
func setInfo(infos):
	for child in get_children():
		remove_child(child)
	for info in infos:
		var container = HBoxContainer.new()
		var img = TextureRect.new()
		var lbl = Label.new()
		container.add_child(img)
		container.add_child(lbl)
		add_child(container)
		print("Container created")
		img.texture = load("res://Misc/ButtonIcons/{b}.png".format({
			"b": info.button
		}))
		lbl.text = info.text