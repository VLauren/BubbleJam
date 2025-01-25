extends Camera3D

@export var offset : Vector3
@export var smooth_factor : float

@export var minPos : Vector2
@export var maxPos : Vector2

var player : CharacterBody3D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	# print(str(player.position) + " " + str(position))
	# if(player.is_on_floor())
	position = lerp(position, player.position + offset, smooth_factor * delta)
