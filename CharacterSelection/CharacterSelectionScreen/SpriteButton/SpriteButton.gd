extends Button

var sprite

var initialized = false

func _ready():
	pass
	
func init(item):
	initialized = true
	sprite = item.texture
	$Sprite.texture = sprite
	
func clear():
	initialized = false
	sprite = null
	$Sprite.texture = sprite