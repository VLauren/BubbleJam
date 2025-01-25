extends CanvasLayer

var startTime
var music : AudioStreamPlayer2D

func _ready() -> void:
	startTime = Time.get_ticks_msec()
	music = AudioManagerGlobal.play_sound("res://Audio/menu_music.ogg")

func _process(delta: float) -> void:
	if(Time.get_ticks_msec() - startTime < 1000):
		return
		
	# if(Input.is_action_just_pressed("ui_accept")):
	# elif(Input.is_anything_pressed()):
	if(Input.is_action_pressed("ui_cancel")):
		get_tree().quit()
	elif(Input.is_anything_pressed()):
		music.stop()
		get_tree().change_scene_to_file("res://Scenes/levels/level01.tscn")
	
# func _unhandled_input(event: InputEvent) -> void:
	# print(event)
