extends HBoxContainer

var BattleDisplay = load("res://Battle/BattleDisplay/BattleDisplay.tscn")

var battleDisplays = []

func init(attack, context, characters):
	
	for idx in range(characters.size()):
		var character = characters[idx]
		var battleDisplay = BattleDisplay.instance()
		
		add_child(battleDisplay)
		
		battleDisplay.init(attack, character, idx == 0)
		
		battleDisplay.connect("finished", context, "onFinished")
		battleDisplay.connect("done", context, "onDone")
		battleDisplay.connect("notification", context, "onNotification")
		
		battleDisplays.append(battleDisplay)
	return battleDisplays