extends KinematicBody2D

export var GRAVITY : = 1000
export var SPEED : int = 50
var direction = -1
var bodyEntered = false

var V : = Vector2()

func _ready():
	$AnimationPlayer.play("idle")
	
func _process(delta):
	if get_node("skeletonEnemyHealth/ProgressBar").value == 0:
		global.score += 25
		$AnimationPlayer.play("die")
		yield(get_tree().create_timer(0.4),"timeout")
		self.visible = false
		yield(get_tree().create_timer(1),"timeout")
		var player = get_tree().get_root().find_node("player",true,false)
		if player.get_node("suspenseMusic").playing:
			player.get_node("suspenseMusic").playing = false
			player.get_node("backgroundMusic").play(global.backMusicPlaybackPos)
		self.queue_free()
	if bodyEntered and global.health!=0:
		$AnimationPlayer.play("attack")
	if $AnimationPlayer.current_animation == "attack":
		return
	V.x = 0
	
	if global.firstBullyDialogueFinished:
		$AnimationPlayer.play("walk")
		V.x = SPEED * direction
	
	turnAround()
	
	V = move_and_slide(V,Vector2.UP)
	V.y += GRAVITY * delta
	
	
func turnAround():
	if not $RayCast2D.is_colliding() and is_on_floor():
		direction *= -1
		scale.x = -scale.x
	
		
			
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walking():
	$AnimationPlayer.play("walk")
	


func _on_playerDetector_body_entered(body):
	if body.is_in_group("player"):
		bodyEntered = true
		$AnimationPlayer.play("attack")


func _on_AttackDetector_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(10)

func _on_playerDetector_body_exited(body):
	if body.is_in_group("player"):
		bodyEntered = false



	


func _on_collisionTrigger_body_entered(body):
	if body.is_in_group("enemy"):
		$Sprite.flip_h = true
		$RayCast2D.position.x = -385
		$AttackDetector.position.x = 95
		$playerDetector.position.x = 95
		direction *= -1 
