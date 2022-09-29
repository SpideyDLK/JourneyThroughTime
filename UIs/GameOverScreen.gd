extends Control

func _ready():
	$gameoverMusic.play()
	$score/amount.text = str(global.score)
	
func _on_restart_pressed():
	get_tree().change_scene("res://UIs/level1IntroScreen.tscn")
	global.score = 0
	global.health = 100


func _on_quit_pressed():
	get_tree().quit()
