extends Object

signal stateChanged
signal characterSelected
signal buttonInfosChanged

var setup
var grid
var details

var buttonInfos = []

func _init(s, gr, d):
	setup = s
	grid = gr
	details = d
	
func resume():
	pass
	
func standby():
	pass
	
func destroy():
	call_deferred("free")
	
func onSelect(item):
	pass
	
func focusToInventory():
	emit_signal("buttonInfosChanged", buttonInfos)
	
func focusToSelection():
	emit_signal("buttonInfosChanged", buttonInfos)
	
		
func readDir(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	var items = []
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.find(".") == -1:
			var item = load("{p}/{f}/{f}.gd".format({
				"p": path,
				"f": file
			}))
			items.append(item)
		
	dir.list_dir_end()
	return items