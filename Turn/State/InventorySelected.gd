extends "res://Turn/State/State.gd"

var inventory

var character
var characterStats

func _init(c, t, gr).(t, gr):
	character = c
	
	characterStats = turn.team.hud.createCharacterStats(true)
	characterStats.setCharacter(false, character)
	characterStats.listenForAnimationFinished(self, "onAnimationFinished")
	
func openInventory():
	if inventory == null or not is_instance_valid(inventory):
		inventory = turn.createInventory(character, {
			"context": self,
			"onPressed": "onPressed",
			"onFocusEntered": "onFocusEntered"
		})
	else:
		inventory.show()
		
func closeInventory():
	inventory.hide()
		
func onPressed(item):
	if item.is_type("Consumable"):
		item.consume(character)
		character.inventory.removeItem(item)
		
func onAnimationFinished():
	print("Animation finished")
	emit_signal("done", character)
		
func move(delta, direction):
	pass

func onFocusEntered(item):
	pass
	
func resume():
	characterStats.show()
	openInventory()
	
func standby():
	characterStats.hide()
	closeInventory()
	
func destroy():
	inventory.queue_free()
	characterStats.queue_free()
	.destroy()