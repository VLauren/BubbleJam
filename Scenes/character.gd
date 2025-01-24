extends CharacterBody3D

var speed = 5.0
var speed_1 = 5.0
var speed_2 = 3.5
var jump_vel_1 = 8
var jump_vel_2 = 5
var gravity_1 = 20
var gravity_2 = 4

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if jump_count > 1:
			velocity += Vector3(0, -gravity_2, 0) * delta
		else:
			velocity += Vector3(0, -gravity_1, 0) * delta
	else:
		jump_count = 0
		speed = speed_1

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") :
		if jump_count == 0:
			velocity.y = jump_vel_1
			jump_count = 1
		elif jump_count > 0:
			velocity.y = jump_vel_2
			jump_count = 2
			speed = speed_2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "", "")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		# velocity.x = direction.x * speed
		# velocity.z = direction.z * speed
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
