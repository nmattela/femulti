extends Object

signal itemAdded
signal itemRemoved

var maxAmount = 3

var items = []

var selectedWeapon
var selectedStaff

func addItem(item):
	if items.size() < maxAmount:
		items.append(item)
		emit_signal("itemAdded", item)
	
func removeItem(item):
	items.erase(item)
	emit_signal("itemRemoved", item)
	
func size():
	return items.size()
	
func getWeapons():
	var weapons = []
	for item in items:
		if item.is_type("Weapon"):
			weapons.append(item)
	return weapons
	
func getStaffs():
	var staffs = []
	for item in items:
		if item.is_type("Staff"):
			staffs.append(item)
	return staffs
	
func getSelectedWeapon():
	if selectedWeapon != null:
		return selectedWeapon
	else:
		var weapons = getWeapons()
		if weapons.size() > 0:
			return weapons[0]
			
func getSelectedStaff():
	if selectedStaff != null:
		return selectedStaff
	else:
		var staffs = getStaffs()
		if staffs.size() > 0:
			return staffs[0]