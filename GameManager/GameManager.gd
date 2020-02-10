extends Node

onready var Grid = preload("res://Grid/Grid.tscn")
onready var Team = preload("res://Team/Team.tscn")
onready var Character = preload("res://Character/Character.tscn")

var teams = []

var main

func _ready():
	main = get_parent()
	
func init(map, teamSetups):
	var grid = Grid.instance()
	add_child(grid)
	grid.name = "Grid"
	grid.init(map)
	
	for team in teamSetups:
		grid.add_child(team.team)
		teams.append(team.team)
		team.team.addToGrid(grid, main.get_node("HUD"), team.characterSetups)
		team.team.connect("finished", self, "nextTurn")
	teams[0].beginTurn()
	
func nextTurn(teamNumber):
	teams[(teamNumber + 1) % teams.size()].beginTurn()