extends Node2D

signal finished

var NothingSelected = load("res://Turn/State/NothingSelected.gd")
onready var BattleMenu = preload("res://BattleMenu/Menu.tscn")

var myTurn = false

var stateHistory = []
var charactersFinished = []

var team
var grid

func _ready():
	team = get_parent()
	grid = team.grid
	position = grid.map_to_cell(Vector2(0, 0)).position
	
func _process(delta):
	if myTurn:
		var direction = Vector2(0, 0)
		
		if Input.is_action_pressed("ui_up"):
			direction.y = -1
		elif Input.is_action_pressed("ui_down"):
			direction.y = 1
			
		if Input.is_action_pressed("ui_left"):
			direction.x = -1
		elif Input.is_action_pressed("ui_right"):
			direction.x = 1
			
		if Input.is_action_just_pressed("ui_select"):
			state().spaceBarPressed()
		elif Input.is_action_just_pressed("ui_cancel"):
			returnState()
		
		if state() != null:
			state().move(delta, direction)
	
func mapPosition():
	return grid.world_to_map(position)
	
func allCharactersFinished():
	return charactersFinished.find(false) == -1
	
func isCharacterFinished(character):
	return charactersFinished[character.characterNumber] or character.dead
	
func begin():
	charactersFinished = []
	myTurn = true
	for character in team.characters:
		charactersFinished.append(false)
		character.indicateMovable()
	addState(NothingSelected.new(self, grid))
	
func end():
	myTurn = false
	emit_signal("finished")
	
func addState(newState):
	if state() != null:
		state().standby()
	stateHistory.push_front(newState)
	state().resume()
	state().connect("stateChanged", self, "addState")
	state().connect("done", self, "onDone")
	
func returnState():
	if stateHistory.size() > 1:
		state().destroy()
		stateHistory.pop_front()
		state().resume()
		state().connect("stateChanged", self, "addState")
		state().connect("done", self, "onDone")
		
func characterDone(character):
	charactersFinished[character.characterNumber] = true
	character.updateGridPos()
	character.indicateUnmovable()
	
		
func onDone(character):
	characterDone(character)
	state().destroy()
	stateHistory.pop_front()
	for state in stateHistory:
		state.call_deferred("free")
	stateHistory = []
	if allCharactersFinished():
		end()
	else:
		addState(NothingSelected.new(self, grid))
	
func state():
	return stateHistory.front()
	
func openMenu(config):
	var battleMenu = BattleMenu.instance()
	var selectorCell = grid.world_to_cell(position)
	var rightFree = grid.inBounds(selectorCell.mapPosition + Vector2(1, 0))
	var menuCell
	if rightFree:
		menuCell = grid.map_to_cell(selectorCell.mapPosition + Vector2(1, 0))
	else:
		menuCell = grid.map_to_cell(selectorCell.mapPosition - Vector2(1, 0))
	battleMenu.init(menuCell.position - selectorCell.position - grid.halfTileSize, config)
	add_child(battleMenu)
	return battleMenu
	
func hideSelector():
	$HookTopLeft.hide()
	$HookTopRight.hide()
	$HookBottomRight.hide()
	$HookBottomLeft.hide()
	
func showSelector():
	$HookTopLeft.show()
	$HookTopRight.show()
	$HookBottomRight.show()
	$HookBottomLeft.show()