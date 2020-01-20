extends Node2D

var itemType

func _ready():
	pass

func init(it):
	itemType = it
	$Sprite.texture = itemType.texture