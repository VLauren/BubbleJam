extends Camera3D

@export var offset : Vector3
@export var smooth_factor : float

@export var minPos : Vector2
@export var maxPos : Vector2

var player : CharacterBody3D
var direction = 1

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	# print(str(player.position) + " " + str(position))
	var target = player.position
	
	if(not player.is_on_floor() and ((position.y - offset.y) - target.y) < -0.5):
		target.y = position.y - offset.y
	if player.velocity.x > 0:
		direction = 1
	if player.velocity.x < 0:
		direction = -1
	
	target.x += direction * 2.5
		
	position = lerp(position, target + offset, smooth_factor * delta)
