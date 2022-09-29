extends Control

func _ready():
	$background.play(global.startScreenMusicPlayBackPos)
	
func _on_back_pressed():
	global.startScreenMusicPlayBackPos = $background.get_playback_position()
	get_tree().change_scene("res://UIs/StartScreen.tscn")
	
