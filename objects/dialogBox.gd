extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file

var dialogues = []
var current_dialogue_id = 0
var isDialogActive = false

func _ready():
	$dialogBox.visible = false
	
func play():
	if isDialogActive:
		return
	dialogues = load_dialogue()
	turnOffPlayer()
	
	isDialogActive = true
	$dialogBox.visible = true
	current_dialogue_id = -1
	next_line()
	
func _input(event):
	if not isDialogActive:
		return
			
	if event.is_action_pressed("action"):
		next_line()

func next_line():
	current_dialogue_id += 1
	if current_dialogue_id == 2 and dialogue_file == "res://dialogues/intro.json":
		dreamOver()
	if current_dialogue_id >= len(dialogues):
		isDialogActive = false
		turnOnPlayer()
		if dialogue_file == "res://dialogues/finalbosslvl1.json":
			global.finalBossDialogueFinished = true
		elif dialogue_file == "res://dialogues/firstBully.json":
			global.firstBullyDialogueFinished = true
		elif dialogue_file == "res://dialogues/finalbosslvl2.json":
			global.finalBullyDialogueFinished = true
		elif dialogue_file == "res://dialogues/finaldialogue.json":
			global.finalDialogueFinished = true
			get_tree().change_scene("res://UIs/FinalScene.tscn")
		return
	$dialogBox/name.text = dialogues[current_dialogue_id]["name"]
	$dialogBox/message.text = dialogues[current_dialogue_id]["message"]
	
func load_dialogue():
	var file = File.new()
	print(dialogue_file)
	print(file.file_exists(dialogue_file))
	if file.file_exists(dialogue_file):
		file.open(dialogue_file,file.READ)
		return parse_json(file.get_as_text())
		
func turnOnPlayer():
	var player = get_tree().get_root().find_node("player",true,false)	
	if player:
		player.isIntroFinished = true
		
func turnOffPlayer():
	var player = get_tree().get_root().find_node("player",true,false)	
	if player:
		player.isIntroFinished = false
		
func dreamOver():
	var player = get_tree().get_root().find_node("player",true,false)	
	if player:
		player.isDreamOver = true
		player.get_node("warrior").visible = false
		

