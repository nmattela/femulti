extends HBoxContainer

var CharacterSelectionScreen = load("res://CharacterSelection/CharacterSelection.tscn")
var GameManger = load("res://GameManager/GameManager.tscn")
var HUD = load("res://HUD/HUD.tscn")

var map

func _ready():
	pass

func init(m):
	map = m
	
	$BlueTeam.init(0, map)
	$RedTeam.init(1, map)
	
	$BlueTeam.begin()
	$BlueTeam.connect("finished", self, "startRedTeam")
	
	
func startRedTeam():
	$RedTeam.begin()
	$RedTeam.connect("finished", self, "beginGame")
	
func beginGame():
	var hud = HUD.instance()
	get_parent().add_child(hud)
	var gameManager = GameManger.instance()
	get_parent().add_child(gameManager)
	queue_free()
	
	gameManager.init(map, [$BlueTeam.returnTeam(), $RedTeam.returnTeam()])