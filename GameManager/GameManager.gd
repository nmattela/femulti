extends Node

onready var Grid = preload("res://Level/Grid.tscn")
onready var Team = preload("res://Team/Team.tscn")
onready var Character = preload("res://Character/Character.tscn")

var teams = []

func _ready():
	var grid = Grid.instance()
	add_child(grid)
	grid.name = "Grid"
	
	for x in range(2):
		var team = Team.instance()
		$Grid.add_child(team)
		teams.append(team)
		team.init(
			x,
			[Character.instance(), Character.instance(), Character.instance(), Character.instance(), Character.instance()]
		)
		team.connect("finished", self, "nextTurn")
	
	teams[0].beginTurn()
	
func nextTurn(teamNumber):
	teams[(teamNumber + 1) % teams.size()].beginTurn()