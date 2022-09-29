extends Area2D

var speed = 500
onready var bulletSprite : = get_node("Sprite")
	
func _physics_process(delta):
	position.x -= speed * delta
	
func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		body.hurt(10)
