extends Control

func _ready():
	$background.play(global.startScreenMusicPlayBackPos)
	


func _on_play_pressed():
	get_tree().change_scene("res://UIs/level1IntroScreen.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_instructions_pressed():
	get_tree().change_scene("res://UIs/instructions.tscn")
	global.startScreenMusicPlayBackPos = $background.get_playback_position()
