extends Label
func _ready():
	update_lives()

func update_lives():
	text = "Lives: " + str(get_parent().lives)
