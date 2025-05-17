extends KinematicBody2D

export var SPEED : int = 300
export var GRAVITY : = 1000
export var JUMPFORCE : = 600

var isAttacking = false
var isJumping = false
var isHurting = false
var isIdle = true
var isDead = false
var isIntroFinished = false
var isDreamOver = false

var stateMachine

var V : = Vector2()

onready var playerSprite : = get_node("player")
	

func _ready():
	stateMachine = $AnimationTree.get("parameters/playback")
	if get_tree().current_scene.name == "level1":
		
		yield(get_tree().create_timer(2),"timeout")
		
		$dreamingSound.play()
		yield(get_tree().create_timer(8),"timeout")
		$dreamingSound.playing = false
		var dialogBox = get_node_or_null("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/intro.json"
		if dialogBox:
			dialogBox.play()
			dialogBox.visible = true
			$warrior.visible = true
			$warrior.scale.x = 2
			$warrior.scale.y = 2
		$backgroundMusic.play()
	elif get_tree().current_scene.name == "level2":
		stateMachine.travel("idle")
		isIntroFinished = true
		yield(get_tree().create_timer(0.5),"timeout")
		var dialogBox = get_node_or_null("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/level2Dialog.json"
		if dialogBox:
			dialogBox.play()
			dialogBox.visible = true
		$backgroundMusic2.play()
	else:
		stateMachine.travel("idle")
		isIntroFinished = true
		yield(get_tree().create_timer(0.5),"timeout")
		var dialogBox = get_node_or_null("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/level3Dialog.json"
		if dialogBox:
			dialogBox.play()
			dialogBox.visible = true
		$backgroundMusic3.play()
	
func _physics_process(delta: float) -> void:
	V.x = 0
	var current = stateMachine.get_current_node()
	var playerHealth = get_tree().get_root().find_node("PlayerHealth",true,false)
	if playerHealth.get_child(0).value == 0 and not isDead:
		isDead = true
		get_node("CollisionShape2D").disabled = true
		stateMachine.travel("die")
		$deathSound.play()
		yield(get_tree().create_timer(1.2),"timeout")
		get_tree().change_scene("res://UIs/GameOverScreen.tscn")
		
	if not isIntroFinished:
		if isDreamOver:
			stateMachine.travel("idle")
		elif get_tree().current_scene.name == "level1":
			stateMachine.travel("sleeping")
	else:
		var dialogBox = get_node_or_null("dialogBox")
		dialogBox.visible = false

	if Input.is_action_pressed("move_left") and isIntroFinished and not isAttacking:
		V.x -= SPEED
		playerSprite.flip_h = true
		get_node("player/hitArea").position.x = -35
		
	elif Input.is_action_pressed("move_right") and isIntroFinished and not isAttacking:
		V.x += SPEED
		playerSprite.flip_h = false
		get_node("player/hitArea").position.x = 0
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and isIntroFinished:
		$jumpSound.play()
		isJumping = true
		V.y -= JUMPFORCE 
		
	if Input.is_action_just_pressed("attack") and isIntroFinished:
		isIdle = false
		isAttacking = true
		attack()
		
	if is_on_floor() and V.x != 0 and isIntroFinished and not isAttacking:
		stateMachine.travel("run")
	elif isIdle and isIntroFinished:
		stateMachine.travel("idle")
		
		
	if not is_on_floor():
		if not isAttacking:
			stateMachine.travel("jump")
			isJumping = false
		elif Input.is_action_just_pressed("attack"):
			attack()
		
		
	
	V = move_and_slide(V,Vector2.UP)
	
	V.y += GRAVITY * delta
	
func attack():
	stateMachine.travel("attack")
	$attackSound.play()
	yield(get_tree().create_timer(0.6),"timeout")
	isAttacking = false
	isIdle = true
	
func hurt(health):
	$hurtSound.play()
	var playerHealth = get_tree().get_root().find_node("PlayerHealth",true,false)	
	playerHealth.get_child(0).hurt(health)
	isIdle = false
	stateMachine.travel("hurt")
	yield(get_tree().create_timer(0.4),"timeout")
	isIdle = true
	
	
func _on_hitArea_body_entered(body):
	if body.is_in_group("enemy"):
		body.get_node("skeletonEnemyHealth").get_child(0).hurt(34)
	if body.is_in_group("boss"):
		body.get_node("skeletonBossHealth").get_child(0).hurt(20)
	if body.is_in_group("enemyBully"):
		body.get_node("skeletonEnemyHealth").get_child(0).hurt(50)
		body.get_node("AnimationPlayer").play("hurt")


func _on_dialogueTrigger_body_entered(body):
	if not global.firstEnemyDialogueFinished and body.is_in_group("player"):
		global.firstEnemyDialogueFinished = true
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/firstEnemy.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_cemetaryDialogueTrigger_body_entered(body):
	if not global.cemetaryDialogueFinished and body.is_in_group("player"):
		
		global.cemetaryDialogueFinished = true
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/cemetary.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_cemetaryMusicTrigger_body_entered(body):
	if $backgroundMusic.playing and body.is_in_group("player"):
		global.backMusicPlaybackPos = $backgroundMusic.get_playback_position()
		$backgroundMusic.stop()
		$cemetaryMusic.play()


func _on_cemetaryMusicTrigger_body_exited(body):
	if $cemetaryMusic.playing and body.is_in_group("player"):
		$cemetaryMusic.stop()
		$backgroundMusic.play(global.backMusicPlaybackPos)


func _on_firstEnemyMusicTrigger_body_entered(body):
	if $backgroundMusic.playing and body.is_in_group("player"):
		global.backMusicPlaybackPos = $backgroundMusic.get_playback_position()
		$backgroundMusic.stop()
		$suspenseMusic.play()


func _on_firstEnemyMusicTrigger_body_exited(body):
	if $suspenseMusic.playing and body.is_in_group("player"):
		$suspenseMusic.stop()
		$backgroundMusic.play(global.backMusicPlaybackPos)


func _on_finalBossDialogureTrigger_body_entered(body):
	if not global.finalBossDialogueFinished and body.is_in_group("player"):
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/finalbosslvl1.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_finalBossMusicTrigger_body_entered(body):
	if $backgroundMusic.playing and body.is_in_group("player"):
		global.backMusicPlaybackPos = $backgroundMusic.get_playback_position()
		$backgroundMusic.stop()
		$finalBoss.play()


func _on_finalBossMusicTrigger_body_exited(body):
	if $finalBoss.playing and body.is_in_group("player"):
		$finalBoss.stop()
		$backgroundMusic.play(global.backMusicPlaybackPos)


func _on_firstBullyDialogueTrigger_body_entered(body):
	if not global.firstBullyDialogueFinished and body.is_in_group("player"):
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/firstBully.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_finalBullyMusicTrigger_body_entered(body):
	if $backgroundMusic.playing and body.is_in_group("player"):
		global.backMusicPlaybackPos = $backgroundMusic.get_playback_position()
		$backgroundMusic.stop()
		$finalBoss.play()
		



func _on_finalBullyMusicTrigger_body_exited(body):
	if $finalBoss.playing and body.is_in_group("player"):
		$finalBoss.stop()
		$backgroundMusic.play(global.backMusicPlaybackPos)


func _on_finalBullyDialogureTrigger_body_entered(body):
	if not global.finalBullyDialogueFinished and body.is_in_group("player"):
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/finalbosslvl2.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_finalDialogueTrigger_body_entered(body):
	if not global.finalDialogueFinished and body.is_in_group("player"):
		var dialogBox = body.get_node("dialogBox")
		dialogBox.dialogue_file = "res://dialogues/finaldialogue.json"
		dialogBox.play()
		dialogBox.visible = true


func _on_pitDetector_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(100)


func _on_portal_body_entered(body):
	if body.is_in_group("player") and get_tree().current_scene.name=="level1":
		body.visible = false
		$portal.play()
		yield(get_tree().create_timer(4),"timeout")
		body.queue_free()
		get_tree().change_scene("res://UIs/level2IntroScreen.tscn")
	else:
		body.visible = false
		$portal.play()
		$backgroundMusic2.stop()
		yield(get_tree().create_timer(4),"timeout")
		body.queue_free()
		get_tree().change_scene("res://UIs/level3IntroScreen.tscn")


func _on_spikeDetector_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(20)
