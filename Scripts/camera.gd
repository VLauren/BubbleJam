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
	
	# print(((position.y - offset.y) - target.y))
	var lockY = false
	if(not player.is_on_floor()):
		lockY = true
		# if (((position.y - offset.y) - target.y) < -0.5) and ((position.y - offset.y) - target.y) > -8:
		# print(abs(position.y - target.y))
		if(abs(position.y - target.y) > 4):
			lockY = false
			
	# if(lockY):
		# target.y = position.y - offset.y
			
	if player.velocity.x > 0:
		direction = 1
	if player.velocity.x < 0:
		direction = -1
	target.x += direction * 2.5
		
	# position = lerp(position, target + offset, smooth_factor * delta)
	position.x = lerp(position.x, target.x + offset.x, smooth_factor * delta)
	if(not lockY):
		if(position.y > target.y):
			position.y = lerp(position.y, target.y + offset.y, smooth_factor * delta)
			# position.y = move_toward(position.y, target.y + offset.y, 0.1)
		else:
			position.y = lerp(position.y, target.y + offset.y, smooth_factor * 0.1 * delta)
			# position.y = move_toward(position.y, target.y + offset.y, 0.01)
	
	if(position.x < minPos.x):
		position.x = minPos.x
	if(position.y < minPos.y):
		position.y = minPos.y
	if(position.x > maxPos.x):
		position.x = maxPos.x
	if(position.y > maxPos.y):
		position.y = maxPos.y
		
