extends ProgressBar


func hurt(health):
	self.value -= health
	
func heal(health):
	self.value += health
