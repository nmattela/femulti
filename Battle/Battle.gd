extends CanvasLayer

onready var HealthBar = preload("res://HUD/HealthBar/HealthBar.tscn")

signal battleFinished

var ally
var enemy
var attack

var allyBattleDisplay
var enemyBattleDisplay

var moves = []

func _ready():
	pass

func init(at, a, e):
	attack = at
	ally = a
	enemy = e
	
	var battleDisplays = $BattleDisplays.init(attack, self, [ally, enemy])
	allyBattleDisplay = battleDisplays[0]
	enemyBattleDisplay = battleDisplays[1]
	
	if attack:
		var attackMoves = ally.calculateAttack(enemy, ally.inventory.getSelectedWeapon())
		for attackMove in attackMoves:
			addAttackMove(attackMove)
	else:
		var assistMoves = ally.calculateAssist(enemy, ally.inventory.getSelectedStaff())
		for assistMove in assistMoves:
			addAssistMove(assistMove)
			
func addAssistMove(assistMove):
	moves.append({
		"ally": ally,
		"target": enemy,
		"returning": false,
		"allyHeal": assistMove.ally.heal,
		"targetHeal": assistMove.target.heal
	})
	
func addAttackMove(attackMove):
	randomize()
	moves.append({
		"ally": attackMove.attacker,
		"target": attackMove.target,
		"returning": false,
		"miss": randf() < attackMove.miss,
		"crit": randf() < attackMove.crit,
		"damage": attackMove.damage,
		"heal": attackMove.heal
	})
	
func onFinished():
	emit_signal("battleFinished")
	queue_free()
	
func onDone():
	moves.pop_front()
	
func onNotification(text):
	$Notification.text = text
	
func _process(delta):
	if moves.size() > 0:
		var move = moves[0]
		if move.ally == ally:
			allyBattleDisplay.engage(move, delta)
		else:
			enemyBattleDisplay.engage(move, delta)
	elif moves.size() <= 0:
		onFinished()