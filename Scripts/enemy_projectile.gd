extends Area3D

var speed = 7

func start(_transform, _player):
	transform = _transform
	look_at(_player.position)

func _process(delta: float) -> void:
	position -= transform.basis.z * speed * delta

func _on_area_shape_entered(area_rid: RID, area, area_shape_index: int, local_shape_index: int) -> void:
	if(area.is_in_group("player")):
		area.get_parent().fall()

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player")):
		body.death()
		queue_free()
