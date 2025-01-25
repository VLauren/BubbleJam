extends CharacterBody3D

@export var ProjectileScene : PackedScene

enum {MOVING, SHOOTING}

const SPEED = 2.0

var player : CharacterBody3D
var camera

var direction = Vector2.ZERO
var previousPosition
var changingDirection = false

var state = MOVING
var count = 0

var canShoot = false

var lastAnimationName = ""

func _ready() -> void:
	direction = Vector2(1, 0)
	previousPosition = position
	player = get_tree().get_nodes_in_group("player")[0]
	changeAnimation("enemy_idle")
	
	await get_tree().create_timer(3).timeout
	
	canShoot = true
	
func _process(delta: float) -> void:
	
	var rot : float
	rot = $EnemyRubish.rotation.y
	if(velocity.x > 0):
		rot = rotate_toward($EnemyRubish.rotation.y, PI/2+0.01, delta * 6)
	if(velocity.x < 0):
		rot = rotate_toward($EnemyRubish.rotation.y, -PI/2-0.01, delta * 6)
	$EnemyRubish.rotation.y = rot
		
	if(state == MOVING):
		if(position.distance_to(player.position) < 10 && canShoot):
			state = SHOOTING
			shoot()
	if(state == SHOOTING):
		return
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += Vector3.ONE * -20 * delta
		velocity.z = 0

	if(state == MOVING):
		# direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if(not is_on_floor()):
			position = previousPosition
			change_direction()
			
		previousPosition = position
		
	if(state == SHOOTING):
		return
	
func change_direction():
	if(not changingDirection):
		changingDirection = true
		var newDirection = -direction
		direction = Vector2.ZERO
		await get_tree().create_timer(1.0).timeout
		direction = newDirection
		changingDirection = false

func shoot():
	canShoot = false
	changeAnimation("enemy_fire")
	await get_tree().create_timer(1).timeout
	
	# spawn projectil
	print("shoot!")
	var p = ProjectileScene.instantiate()
	get_tree().root.add_child(p)
	p.start(transform, player)
	
	await get_tree().create_timer(0.5).timeout
	
	state = MOVING
	
	await get_tree().create_timer(2).timeout
	
	canShoot = true

func death():
	print("enemy death")
	queue_free()
	
func changeAnimation(animationName, transitionTime = 0.1):
	if(animationName != lastAnimationName):
		print(animationName)
		lastAnimationName = animationName
		$EnemyRubish/AnimationPlayer.play(animationName, transitionTime, 1)
