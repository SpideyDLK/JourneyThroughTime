extends StaticBody2D

func _ready():
	$AnimatedSprite.play("closed")



func _on_detector_body_entered(body):
	if body.is_in_group("player"):
		$AnimatedSprite.play("opening")
		if $doorCollision:
			$doorCollision.queue_free()


func _on_detector_body_exited(body):
	if body.is_in_group("player"):
		$AnimatedSprite.play("closing")
		
