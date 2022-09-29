extends Area2D

func _on_silverCoin_body_entered(body):
	if body.is_in_group("player") and self.visible:
		global.score += 10
		body.get_node("coinSound").play()
		self.queue_free()
