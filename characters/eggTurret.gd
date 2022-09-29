extends StaticBody2D

var bullet = preload("res://objects/bullet.tscn")
onready var gunPos = $Position2D

var _timer = null


func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	var new_bullet = bullet.instance()
	new_bullet.position = gunPos.global_position
	get_tree().current_scene.add_child(new_bullet)
	
