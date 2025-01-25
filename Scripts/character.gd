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
var input_dir : Vector2

var lastAnimationName = ""

func _ready() -> void:
	$CharacterBase/AnimationPlayer.play("Idle 1")

func _process(delta: float) -> void:
	$Bubble.scale = Vector3.ONE * move_toward($Bubble.scale.x, target_bubble_size, 0.1)
	if(target_bubble_size == 0):
		$Bubble.scale = Vector3.ZERO
	
	var rot : float
	rot = $CharacterBase.rotation.y
	if(velocity.x > 0):
		rot = rotate_toward($CharacterBase.rotation.y, PI/2+0.01, delta * 10)
	if(velocity.x < 0):
		rot = rotate_toward($CharacterBase.rotation.y, -PI/2-0.01, delta * 10)
	$CharacterBase.rotation.y = rot
	
	#animaciones
	if(is_on_floor()):
		if(input_dir.x != 0):
			changeAnimation("Standard Run")
		else:
			changeAnimation("Idle 1")

func _physics_process(delta: float) -> void:
	# gravedad
	if not is_on_floor():
		if jump_count > 1: 
			velocity += Vector3(0, -gravity_2, 0) * delta
		else:
			velocity += Vector3(0, -gravity_1, 0) * delta
			cant_jump = false
	# volver a tocar el suelo
	else:
		jump_count = 0
		speed = speed_1
		cant_jump = false
	
	# tamaño de la pompa
	target_bubble_size = jump_count * 1.0
	if(jump_count > 1):
		target_bubble_size += 0.5
	elif jump_count == 1:
		target_bubble_size -= 1
	if(cant_jump):
		target_bubble_size = 0
		
	# saltitos
	if Input.is_action_just_pressed("ui_accept") and not cant_jump:
		if jump_count == 0:
			if(is_on_floor()):
				velocity.y = jump_vel_1
				jump_count += 1
				changeAnimation("JumpCortado")
			else:
				velocity.y = jump_vel_2
				jump_count += 2
				changeAnimation("Floating")
		elif jump_count > 0 and jump_count < max_jumps:
			velocity.y = jump_vel_2
			jump_count += 1
			speed = speed_2
			changeAnimation("Floating", 0.5)
		elif jump_count >= max_jumps:
			fall()
		

	# el fast fall
	if not is_on_floor() and Input.is_action_just_pressed("ui_down"):
		fall()
		velocity.y = -10
		

	# input derecha-izquierda
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
	cant_jump = true
	changeAnimation("JumpCortado")

func _on_bubble_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.

func _on_bubble_body_entered(body) -> void:
	if(not body.is_in_group("player")):
		if(body.is_in_group("enemy")):
			body.death()
		await get_tree().process_frame
		print(body)
		fall()

func death():
	get_tree().reload_current_scene()
	
func changeAnimation(animationName, transitionTime = 0.1):
	# if(animationName != $CharacterBase/AnimationPlayer.current_animation):
	if(animationName != lastAnimationName):
		print(animationName)
		lastAnimationName = animationName
		$CharacterBase/AnimationPlayer.play(animationName, transitionTime, 1)
