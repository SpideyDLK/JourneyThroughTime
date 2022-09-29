extends Area2D

func _ready():
	$AnimationPlayer.play("idle")
	
func _on_hammer_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(100)
