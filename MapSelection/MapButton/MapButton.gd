extends Button

signal mapSelected

var Map = load("res://Map/Map.gd")

var map
var preview

func _ready():
	connect("pressed", self, "onPressed")

func init(mapFile):
	
	$Name.text = mapFile
	
	map = Map.new(mapFile)
	
	var img = Image.new()
	img.create(map.size.x, map.size.y, false, Image.FORMAT_ETC2_RGB8)
	
#	img.lock()
#
#	for x in img.get_width():
#		for y in img.get_height():
#			img.set_pixel(x, y, Color(1, 0, 0))
#
#	img.unlock()
#
#	img.resize(100, 100)
			
	preview = ImageTexture.new()
	preview.create_from_image(img)
	
	$Preview.texture = preview
	
func onPressed():
	emit_signal("mapSelected")