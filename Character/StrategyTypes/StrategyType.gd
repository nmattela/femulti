extends Object

#Stats
var maxHealth = 10
var maxMovement = 20
var agility = 1
var strength = 1
var crit = 1


var texture

var type = "Knight"
var teamNumber

var animation = {
	"direction": Vector2(0, 0),
	"cycle": 0,
	"timeout": 0,
	"maxTimeout": 5
}

func _init(teamNo):
	teamNumber = teamNo
	texture = load("res://Character/StrategyTypes/{t}/{teamNo}/still_0.png".format({
		"t": type,
		"teamNo": teamNumber
	}))
	
func animateMovement(direction):
	if animation.timeout == 0 or direction == Vector2(0, 0):
		var newTexture = "res://Character/StrategyTypes/{t}/{teamNo}/{mov}_{c}.png"
		var right = false
		if direction == Vector2(0, -1):
			newTexture = newTexture.format({
				"mov": "back"
			})
		elif direction == Vector2(1, 0):
			newTexture = newTexture.format({
				"mov": "horizontal"
			})
			right = true
		elif direction == Vector2(0, 1):
			newTexture = newTexture.format({
				"mov": "front"
			})
		elif direction == Vector2(-1, 0):
			newTexture = newTexture.format({
				"mov": "horizontal"
			})
		elif direction == Vector2(0, 0):
			newTexture = newTexture.format({
				"mov": "still",
				"c": 0
			})
			
		newTexture = newTexture.format({
			"t": type,
			"teamNo": teamNumber,
			"c": animation.cycle
		})
			
		texture = load(newTexture)
		if right:
			var img = texture.get_data()
			var imageTexture = ImageTexture.new()
			img.flip_x()
			imageTexture.create_from_image(img)
			imageTexture.flags = 0
			texture = imageTexture
			
		animation.timeout = animation.maxTimeout
		animation.cycle = (animation.cycle + 1) % 3
	else:
		animation.timeout -= 1