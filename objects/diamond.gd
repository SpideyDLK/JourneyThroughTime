extends Area2D


func _on_diamond_body_entered(body):
	if body.is_in_group("player") and self.visible:
		global.score += 100
		body.get_node("diamondSound").play()
		self.queue_free()
