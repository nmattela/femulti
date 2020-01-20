extends Node2D

var speed
var velocity

var maxSpeed = 400
var grid

var isMoving = false
var targetPos = Vector2()
var targetDir = Vector2()

var direction = Vector2()

onready var NoSelect  = load("res://Selector/NoSelect.gd")
onready var Character = preload("res://Character/Character.tscn")
onready var BattleMenu = preload("res://BattleMenu/Menu.tscn")

var state

func _ready():
	grid = get_parent()
	onStateChanged(NoSelect.new(grid, self))
	
func onStateChanged(newState):
	state = newState
	state.connect("stateChanged", self, "onStateChanged")

func _process(delta):
	direction = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
		
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
		
	if Input.is_action_just_pressed("ui_select"):
		state.spaceBarPressed(position)
		
		
	state.animateMovement(delta)
	
	
func openMenu(config):
	var battleMenu = BattleMenu.instance()
	var selectorCell = grid.getCell(position)
	var rightFree = grid.inBounds(selectorCell.mapPosition + Vector2(1, 0))
	var menuCell
	if rightFree:
		menuCell = grid.getCell(selectorCell.mapPosition + Vector2(1, 0), false)
	else:
		menuCell = grid.getCell(selectorCell.mapPosition - Vector2(1, 0), false)
	battleMenu.init(menuCell.position - selectorCell.position - grid.halfTileSize, config)
	add_child(battleMenu)
	return battleMenu