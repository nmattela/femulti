extends VBoxContainer

signal finished

var Team = load("res://Team/Team.tscn")

var team

var disabled = false
var confirmable = false

func _ready():
	pass
	
func init(teamNumber, map):
	team = Team.instance()
	team.init(teamNumber, map)
	$SelectionPanel.init(team)
	disable()
	
func begin():
	enable()
	focus()
	
func disable():
	disabled = true
	$SelectionPanel/ListSetupSplitter.disable()
	
func enable():
	disabled = false
	$SelectionPanel/ListSetupSplitter.enable()
	
func allCharactersSetUp():
	confirmable = true
	
func returnTeam():	
	return {
		"team": team,
		"characterSetups": $SelectionPanel/ListSetupSplitter.returnSetUps()
	}
	
func onFinished():
	disable()
	emit_signal("finished")
	
func focus():
	if not disabled:
		$SelectionPanel/ListSetupSplitter/CharacterListScroll/CharacterList.focus()
		
func _process(delta):
	if Input.is_action_just_pressed("ui_x") and confirmable:
		onFinished()
		
func setButtonInfos(infos):
	$ControlInfosPanel/ControlInfos.setInfo(infos)