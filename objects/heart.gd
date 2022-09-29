extends Area2D

func _on_heart_body_entered(body):
	if body.is_in_group("player"):
		global.score += 5
		body.get_node("lifeCollectSound").play()
		var playerHealth = get_tree().get_root().find_node("PlayerHealth",true,false)
		playerHealth.get_child(0).heal(20)
		queue_free()
