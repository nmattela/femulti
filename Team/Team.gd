extends Node

signal finished

onready var Turn      = preload("res://Turn/Turn.tscn")
var Knight    = load("res://Character/StrategyTypes/Knight/Knight.gd")

var Character = load("res://Character/Character.tscn")

var hud
var grid
var characters = []

var teamNumber = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func addToGrid(gr, h, characterSetups):
	grid = gr
	hud = h
	for idx in range(characters.size()):
		add_child(characters[idx])
		characters[idx].init(grid, idx, self, characterSetups[idx].type, characterSetups[idx].inventory)
		characters[idx].indicateIdle()
	var turn = Turn.instance()
	turn.name = "Turn"
	add_child(turn)
	turn.connect("finished", self, "endTurn")
		
func init(teamNo, map):
	teamNumber = teamNo
	for character in map.maxPlayers:
		characters.append(Character.instance())
	
func isTeamMember(character):
	return getTeamMemberIndex(character) != -1
	
func getTeamMemberIndex(character):
	return characters.find(character)

func beginTurn():
	print("{x} begins".format({"x": teamNumber}))
	$Turn.begin()
	
func endTurn():
	emit_signal("finished", teamNumber)