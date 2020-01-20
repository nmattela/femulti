extends Object

var blueColors = [
	Color("#80a080"),
	Color("#584878"),
	Color("#90b8e8"),
	Color("#d8e8f0"),
	Color("#706060"),
	Color("#b09058"),
	Color("#f8f8d0"), #385e0
	Color("#383890"), #Very dark blue
	Color("#3850e0"), #Kinda dark blue
	Color("#28a0f8"), #Kinda light blue
	Color("#18f0f8"), #Very light blue
	Color("#e81018"),
	Color("#f8f840"),
	Color("#808870"),
	Color("#f8f8f8"),
	Color("#403838")
]

var redColors = [
	Color("#80a080"),
	Color("#684860"),
	Color("#c0a8b8"),
	Color("#e0e0e0"),
	Color("#706060"),
	Color("#b09058"),
	Color("#f8f8d0"),
	Color("#602820"),
	Color("#a83028"),
	Color("#e01010"),
	Color("#f85048"),
	Color("#38d030"),
	Color("#f8f840"),
	Color("#808870"),
	Color("#f8f8f8"),
	Color("#403838")
]

var greenColors = [
	Color("#0f130f"),
	Color("#385038"),
	Color("#0f110e"),
	Color("#d8f8b8"),
	Color("#1b1b18"),
	Color("#a08840"),
	Color("#0f0f0c"),
	Color("#205010"),
	Color("#0d120d"),
	Color("#18d010"),
	Color("#50f838"),
	Color("#0078c8"),
	Color("#e0f828"),
	Color("#808870"),
	Color("#f8f8f8"),
	Color("#384038")
]

var usedColors = [
	Color("#101310"),
	Color("#404040"),
	Color("#787878"),
	Color("#b8b8b8"),
	Color("#505050"),
	Color("#808080"),
	Color("#c8c8c8"),
	Color("#484848"),
	Color("#585858"),
	Color("#989898"),
	Color("#b8b8b8"),
	Color("#707070"),
	Color("#707070"),
	Color("#c8c8c8"),
	Color("#808870"),
	Color("#808870"),
	Color("#d0d0d0"),
	Color("#403838")
]

var character
var teamColors
var currentColors = blueColors

func _init(c):
	character = c
	if character.teamNumber == 0:
		teamColors = blueColors
	elif character.teamNumber == 1:
		teamColors = redColors
	setTeamColor()
	
func setTeamColor():
	setColor(teamColors)
	
func setUsedColor():
	setColor(usedColors)
	
func setColor(newColors):
	var img = character.get_node("Sprite").texture.get_data()
	img.lock()
	var counter = 0
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var pixelIndex = currentColors.find(img.get_pixel(x, y))
			if pixelIndex > -1:
				counter += 1
				img.set_pixel(x, y, newColors[pixelIndex])
	img.unlock()
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(img)
	imageTexture.flags = 0
	character.get_node("Sprite").texture = imageTexture
	currentColors = newColors
	