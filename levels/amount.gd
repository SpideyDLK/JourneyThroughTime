extends RichTextLabel


func _process(delta):
	self.text = str(global.score)
