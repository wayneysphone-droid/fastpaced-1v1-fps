extends CharacterBody3D
class_name PlayerController

# Movement properties
var move_speed: float = 7.0
var jump_force: float = 12.0
var friction: float = 0.15
var acceleration: float = 0.25

# Slide mechanics
var slide_speed_boost: float = 1.5
var slide_duration: float = 0.6
var is_sliding: bool = false
var slide_timer: float = 0.0

# Dash mechanics
var dash_force: float = 30.0
var dash_cooldown: float = 1.2
var last_dash_time: float = -999.0
var can_dash: bool = true

# Camera
var camera_3d: Camera3D = null
var camera_sensitivity: float = 0.003
var camera_recoil: float = 0.0
var max_look_angle: float = 90.0

# Health and combat
var max_health: float = 150.0
var current_health: float = 150.0
var is_alive: bool = true

# Weapon system
var current_weapon: WeaponBase = null
var weapon_manager: Node = null

# Gravity
var gravity: float = 25.0

# Input
var input_direction: Vector3 = Vector3.ZERO

# Signals
signal health_changed(new_health: float)
signal died

func _ready() -> void:
	# Setup camera
	camera_3d = Camera3D.new()
	add_child(camera_3d)
	camera_3d.position.y = 1.7  # Eye height
	
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	current_health = max_health

func _process(delta: float) -> void:
	# Handle input
	handle_input()
	
	# Update camera recoil
	update_camera_recoil(delta)
	
	# Handle weapon firing
	if current_weapon:
		if Input.is_action_pressed("fire"):
			current_weapon.start_firing()
		else:
			current_weapon.stop_firing()
		
		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()

func _physics_process(delta: float) -> void:
	if not is_alive:
		return
	
	# Get input
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	input_direction = input_direction.normalized()
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Handle sliding
	if Input.is_action_just_pressed("slide") and is_on_floor() and input_direction.length() > 0:
		start_slide()
	
	# Handle dashing
	if Input.is_action_just_pressed("dash") and can_dash:
		perform_dash()
	
	# Update slide timer
	if is_sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			is_sliding = false
	
	# Apply movement
	apply_movement(delta)
	
	# Apply gravity
	velocity.y -= gravity * delta
	
	# Move character
	move_and_slide()

func handle_input() -> void:
	"""Handle mouse input for camera look"""
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func apply_movement(delta: float) -> void:
	"""Apply movement with acceleration and friction"""
	var move_speed_current = move_speed
	
	# Apply weapon movement modifier
	if current_weapon:
		move_speed_current *= current_weapon.apply_movement_modifier()
	
	# Apply slide boost
	if is_sliding:
		move_speed_current *= slide_speed_boost
	
	# Get camera forward direction
	var forward = -camera_3d.global_transform.basis.z
	var right = camera_3d.global_transform.basis.x
	
	# Build movement vector
	var target_velocity = (forward * input_direction.y + right * input_direction.x) * move_speed_current
	target_velocity.y = velocity.y  # Preserve vertical velocity
	
	# Apply acceleration/friction
	velocity.x = lerp(velocity.x, target_velocity.x, acceleration)
	velocity.z = lerp(velocity.z, target_velocity.z, acceleration)

func start_slide() -> void:
	"""Start sliding"""
	if is_sliding:
		return
	is_sliding = true
	slide_timer = slide_duration

func perform_dash() -> void:
	"""Perform dash in camera direction"""
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_dash_time < dash_cooldown:
		return
	
	can_dash = false
	last_dash_time = current_time
	
	var dash_direction = -camera_3d.global_transform.basis.z
	velocity += dash_direction * dash_force
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func update_camera_recoil(delta: float) -> void:
	"""Update camera recoil decay"""
	camera_recoil = lerp(camera_recoil, 0.0, 0.15)

func add_camera_recoil(amount: float) -> void:
	"""Add recoil to camera"""
	camera_recoil += amount

func take_damage(damage: float, damage_type: String = "body") -> void:
	"""Take damage"""
	if not is_alive:
		return
	
	# Apply damage type multiplier
	var final_damage = damage
	match damage_type:
		"headshot":
			final_damage *= 1.5
		"legshot":
			final_damage *= 0.75
		_:
			pass
	
	current_health -= final_damage
	health_changed.emit(current_health)
	
	if current_health <= 0:
		die()

func die() -> void:
	"""Handle player death"""
	is_alive = false
	died.emit()

func respawn(position: Vector3) -> void:
	"""Respawn the player"""
	global_position = position
	current_health = max_health
	is_alive = true
	velocity = Vector3.ZERO
	health_changed.emit(current_health)

func set_weapon(weapon: WeaponBase) -> void:
	"""Set the current weapon"""
	current_weapon = weapon
	current_weapon.player_controller = self

func get_health_percentage() -> float:
	"""Get health as percentage"""
	return current_health / max_health

func get_movement_speed() -> float:
	"""Get current movement speed"""
	var base_speed = move_speed
	if current_weapon:
		base_speed *= current_weapon.apply_movement_modifier()
	if is_sliding:
		base_speed *= slide_speed_boost
	return base_speed