extends CharacterBody3D

@export var xLimit = Vector2(-5, 1000)

const max_jumps = 5

var speed = 5.0
var speed_1 = 5.0
var speed_2 = 3.5
var jump_vel_1 = 9
var jump_vel_2 = 5
var gravity_1 = 20
var gravity_2 = 4

var jump_count = 0

var cant_jump = false

var target_bubble_size = 0

func _process(delta: float) -> void:
	$Bubble.scale = Vector3.ONE * move_toward($Bubble.scale.x, target_bubble_size, 0.1)
	if(target_bubble_size == 0):
		$Bubble.scale = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# gravedad
	if not is_on_floor():
		if jump_count > 1: 
			# Add the gravity.
			velocity += Vector3(0, -gravity_2, 0) * delta
		else:
			velocity += Vector3(0, -gravity_1, 0) * delta
			cant_jump = false
	# volver a tocar el suelo
	else:
		jump_count = 0
		speed = speed_1
	
	# tamaño de la pompa
	target_bubble_size = jump_count * 1.0
	if(jump_count > 1):
		target_bubble_size += 0.5
	else:
		target_bubble_size -+ 1
	if(cant_jump):
		target_bubble_size = 0
		
	# saltitos
	if Input.is_action_just_pressed("ui_accept") :
		if jump_count == 0:
			velocity.y = jump_vel_1
			jump_count += 1
		elif jump_count > 0 and jump_count < max_jumps:
			velocity.y = jump_vel_2
			jump_count += 1
			speed = speed_2
		elif jump_count >= max_jumps:
			fall()
		

	# el fast fall
	if not is_on_floor() and Input.is_action_pressed("ui_down"):
		fall()
		velocity.y = -4

	# input derecha-izquierda
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, 1)
		velocity.z = move_toward(velocity.z, direction.z * speed, 1)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 0.4)
			velocity.z = move_toward(velocity.z, 0, 0.4)
		else:
			velocity.x = move_toward(velocity.x, 0, 0.1)
			velocity.z = move_toward(velocity.z, 0, 0.1)

	move_and_slide()
	
	if(position.x < xLimit.x):
		position.x = xLimit.x
	if(position.x > xLimit.y):
		position.x = xLimit.y
	
	if(position.y < -10):
		death()
	
func fall():
	cant_jump = true
	if(velocity.y > -0.5):
		velocity.y = -0.5

func _on_bubble_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.

func _on_bubble_body_entered(body: Node3D) -> void:
	await get_tree().process_frame
	fall()
	pass # Replace with function body.

func death():
	get_tree().reload_current_scene()
