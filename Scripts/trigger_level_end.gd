extends Area3D

@export var level : String

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_end")):
		next_level(get_tree().get_nodes_in_group("player")[0])

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if(is_instance_valid(body.musicFast) && is_instance_valid(body.musicSlow)):
			body.musicFast.stop()
			body.musicSlow.stop()
		next_level(body)

func next_level(body):
	if(is_instance_valid(body.musicFast) && is_instance_valid(body.musicSlow)):
			body.musicFast.stop()
			body.musicSlow.stop()
	if(level.is_absolute_path()):
		get_tree().change_scene_to_file(level)
	else:
		print(get_tree().change_scene_to_file("res://Scenes/end_scene.tsc"))
