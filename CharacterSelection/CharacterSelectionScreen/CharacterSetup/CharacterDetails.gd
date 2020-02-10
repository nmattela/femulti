extends VBoxContainer

func _ready():
	pass
	
func init(i):
	$HAlign/Inventory.init(i)
	
func disable():
	hide()
	
func enable():
	show()
	
func focus():
	$HAlign/Inventory.focus()
	
func setDescription(item):
	$DescriptionPanel/Description.text = "{n}: {d}".format({
		"n": item.get_type(),
		"d": item.description
	})
	
func clearInventory():
	$HAlign/Inventory.clear()