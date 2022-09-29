extends Area2D

var alreadyOpened = false
var playerInArea = false

func _input(event):
	if event.is_action_pressed("action") and playerInArea and not alreadyOpened:
		alreadyOpened = true
		$chestOpenSound.play()
		$AnimatedSprite.play("opening")
		yield(get_tree().create_timer(0.4),"timeout")
		$silverCoin.visible = true	

func _on_chest_body_entered(body):
	if body.is_in_group("player"):
		playerInArea = true


func _on_chest_body_exited(body):
	if body.is_in_group("player"):
		playerInArea = false
