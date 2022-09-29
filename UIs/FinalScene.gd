extends Control


func _ready():
	yield(get_tree().create_timer(4),"timeout")
	get_tree().change_scene("res://UIs/StartScreen.tscn")
