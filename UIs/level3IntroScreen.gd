extends Control


func _ready():
	$background.play()
	yield(get_tree().create_timer(4),"timeout")
	get_tree().change_scene("res://levels/level3.tscn")
