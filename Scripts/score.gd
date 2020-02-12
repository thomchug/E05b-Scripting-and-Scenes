extends Label
func _ready():
	update_score()

func update_score():
	text = "Score: " + str(get_parent().score)
