extends Area2D

var isFirstTime = false


func _on_shop_body_entered(body):
	if body.is_in_group("player"):
		if not isFirstTime:
			isFirstTime = true
			var dialogBox = body.get_node("dialogBox")
			dialogBox.dialogue_file = "res://dialogues/shopDialog.json"
			dialogBox.play()
			dialogBox.visible = true
