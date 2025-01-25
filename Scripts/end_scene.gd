extends CanvasLayer

var startTime

func _ready() -> void:
	startTime = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if(Time.get_ticks_msec() - startTime < 1000):
		return
		
	if(Input.is_anything_pressed()):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
