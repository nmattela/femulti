extends Object

var items = []
var selectedWeapon

func addItem(item):
	items.append(item)
	
func getWeapons():
	var weapons = []
	for item in items:
		if item.is_type("Weapon"):
			weapons.append(item)
	return weapons
	
func getSelectedWeapon():
	if selectedWeapon != null:
		return selectedWeapon
	else:
		var weapons = getWeapons()
		if weapons.size() > 0:
			return weapons[0]