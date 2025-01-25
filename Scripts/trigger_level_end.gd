extends Area3D

@export var level : String

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if(level.is_absolute_path()):
			get_tree().change_scene_to_file(level)
		else:
			print(get_tree().change_scene_to_file("res://Scenes/end_scene.tsc"))
