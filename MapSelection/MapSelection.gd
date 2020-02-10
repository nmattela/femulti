extends GridContainer

var MapButton = load("res://MapSelection/MapButton/MapButton.tscn")
var CharacterSelection = load("res://CharacterSelection/CharacterSelection.tscn")
var Map = load("res://Map/Map.gd")

var maps = []

func _ready():
	var dir = Directory.new()
	dir.open("res://Map/Maps")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			maps.append(file)

	dir.list_dir_end()

	var buttons = []
	for map in maps:
		var button = MapButton.instance()
		button.init("res://Map/Maps/{m}".format({"m": map}))
		button.name = map
		add_child(button)

		button.connect("mapSelected", self, "onSelect", [map])

		buttons.append(button)
	buttons[0].grab_focus()
	
func onSelect(mapName):
	var characterSelection = CharacterSelection.instance()
	get_parent().add_child(characterSelection)
	var map = Map.new("res://Map/Maps/{m}".format({"m": mapName}))
	characterSelection.init(map)
	queue_free()