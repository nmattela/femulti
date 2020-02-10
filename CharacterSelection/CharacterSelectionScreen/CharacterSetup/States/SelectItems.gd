extends "res://CharacterSelection/CharacterSelectionScreen/CharacterSetup/States/State.gd"

var Inventory = load("res://Character/Inventory.gd")

var items = []
var itemButtons = {}

func _init(s, gr, d).(s, gr, d):
	setup.inventory = Inventory.new()
	
	var weapons     = readDir("res://Item/Weapons")
	var staffs      = readDir("res://Item/Staffs")
	var consumables = readDir("res://Item/Consumables")
	
	for weapon in weapons:
		items.append(weapon.new())
	for staff in staffs:
		items.append(staff.new())
	for consumable in consumables:
		items.append(consumable.new())
		
	itemButtons = grid.createButtons(items, self)
	details.init(setup.inventory)
	
	focusToSelection()
	
func resume():
	grid.fill(itemButtons)
	
func standby():
	grid.empty(itemButtons)
	
func focusToInventory():
	buttonInfos = [
		{"button": "A", "text": "Remove from Inventory"},
		{"button": "X", "text": "Confirm"},
		{"button": "RjsUp", "text": "Switch to Selection"},
	]
	.focusToInventory()
	
func focusToSelection():
	buttonInfos = [
		{"button": "A", "text": "Add to Inventory"},
		{"button": "X", "text": "Confirm"},
		{"button": "RjsDown", "text": "Switch to Inventory"},
	]
	.focusToSelection()

func destroy():
	grid.empty(itemButtons)
	setup.inventory = null
	print(itemButtons)
	for itemButton in itemButtons:
		itemButton.call_deferred("free")
	details.clearInventory()
	.destroy()
	
func onSelect(item):
	var newItem = load("res://Item/{st}/{t}/{t}.gd".format({"st": item.supertype, "t": item.type})).new()
	setup.inventory.addItem(newItem)
	
func onFocusEntered(item):
	details.setDescription(item)