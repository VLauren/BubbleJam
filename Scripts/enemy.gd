extends CharacterBody3D

@export var ProjectileScene : PackedScene

@export var stepParticleScene : PackedScene
@export var vfx : PackedScene

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
	
		
	if(state == MOVING):
		if(position.distance_to(player.position) < 10 && canShoot):
			state = SHOOTING
			shoot()
		var rot : float
		rot = $EnemyRubish.rotation.y
		if(velocity.x > 0):
			rot = rotate_toward($EnemyRubish.rotation.y, PI/2+0.01, delta * 6)
		if(velocity.x < 0):
			rot = rotate_toward($EnemyRubish.rotation.y, -PI/2-0.01, delta * 6)
		$EnemyRubish.rotation.y = rot
		
	if(state == SHOOTING):
		var rot : float
		rot = $EnemyRubish.rotation.y
		if(player.position.x > position.x):
			rot = rotate_toward($EnemyRubish.rotation.y, PI/2+0.01, delta * 8)
		if(player.position.x < position.x):
			rot = rotate_toward($EnemyRubish.rotation.y, -PI/2-0.01, delta * 8)
		$EnemyRubish.rotation.y = rot
		
	if(velocity.x != 0):
		changeAnimation("enemy_walking")
	
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
	velocity = Vector3.ZERO
	canShoot = false
	changeAnimation("enemy_fire")
	await get_tree().create_timer(0.35).timeout
	
	# spawn projectil
	var p = ProjectileScene.instantiate()
	var a = AudioManagerGlobal.play_sound("res://Audio/lanza" + str(randi_range(1,2)) + ".ogg")
	a.volume_db = 5
	
	get_tree().root.add_child(p)
	p.start($EnemyRubish/ProjectileSpawn.global_transform, player)
	
	await get_tree().create_timer(0.5).timeout
	
	state = MOVING
	
	await get_tree().create_timer(0.5).timeout
	changeAnimation("enemy_idle")
	await get_tree().create_timer(1.5).timeout
	canShoot = true

func death():
	
	var v = vfx.instantiate()
	get_tree().root.add_child(v)
	(v as GPUParticles3D).position = position
	(v as GPUParticles3D).restart()
	
	AudioManagerGlobal.play_sound("res://Audio/muerte_enemy" + str(randi_range(1,2)) + ".ogg")
	
	queue_free()
	
func changeAnimation(animationName, transitionTime = 0.1):
	if(animationName != lastAnimationName):
		print(animationName)
		lastAnimationName = animationName
		$EnemyRubish/AnimationPlayer.play(animationName, transitionTime, 1)
