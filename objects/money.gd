extends Area2D

func _on_money_body_entered(body):
	if body.is_in_group("player") and self.visible:
		global.score += 50
		body.get_node("cashSound").play()
		self.queue_free()
