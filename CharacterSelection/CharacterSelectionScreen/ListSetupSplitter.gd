extends HBoxContainer

var CharacterSetup = load("res://CharacterSelection/CharacterSelectionScreen/CharacterSetup/CharacterSetup.tscn")

var currentSlot
var currentSlotIdx
var setups = []

func init(team):	
	for slot in range(team.characters.size()):
		var characterSetup = CharacterSetup.instance()
		add_child(characterSetup)
		characterSetup.init()
		setups.append(characterSetup)
		
	$CharacterListScroll/CharacterList.init(team)
	
func disable():
	for child in get_children():
		child.disable()
		
func enable():
	for child in get_children():
		child.enable()
	
func onSlotSelected(slot, idx):
	if currentSlot != null:
		setups[currentSlotIdx].close()
	currentSlot = slot
	currentSlotIdx = idx
	setups[currentSlotIdx].open()
	
func allCharactersSetUp():
	for setup in setups:
		if not setup.isSetUp():
			return false
	return true
		
func confirmSetup():
	$CharacterListScroll/CharacterList.focus()
	if currentSlot != null:
		setups[currentSlotIdx].close()
	if allCharactersSetUp():
		get_parent().get_parent().allCharactersSetUp()
	
func setSlotSprite(character):
	if character != null:
		currentSlot.init(character)
	else:
		currentSlot.clear()
		
func returnSetUps():
	var returnedSetups = []
	for setup in setups:
		returnedSetups.append(setup.returnSetUp())
	return returnedSetups