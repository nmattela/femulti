extends Node

signal finished

onready var Turn      = preload("res://Turn/Turn.tscn")
var Knight    = load("res://Character/StrategyTypes/Knight/Knight.gd")

var grid
var characters = []

var teamNumber = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_parent()
		
	var turn = Turn.instance()
	turn.name = "Turn"
	add_child(turn)
	turn.connect("finished", self, "endTurn")
	
func init(teamNo, chs):
	teamNumber = teamNo
	for x in range(chs.size()):
		add_child(chs[x])
		chs[x].init(grid, teamNumber, x, Knight)
		characters.append(chs[x])
	
func isTeamMember(character):
	return getTeamMemberIndex(character) != -1
	
func getTeamMemberIndex(character):
	return characters.find(character)

func beginTurn():
	print("{x} begins".format({"x": teamNumber}))
	$Turn.begin()
	
func endTurn():
	emit_signal("finished", teamNumber)