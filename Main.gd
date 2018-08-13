extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed('key_escape'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()

	if Input.is_action_just_pressed('key_restart'):
		get_tree().reload_current_scene()

