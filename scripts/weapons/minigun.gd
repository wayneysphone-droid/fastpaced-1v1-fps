extends WeaponBase
class_name MinigunWeapon

# Minigun specific
var is_spinning: bool = false
var spin_up_time: float = 0.3
var spin_down_time: float = 0.2
var current_spin_progress: float = 0.0

func _process(delta: float) -> void:
	if is_firing and not is_spinning:
		start_spinup()
	elif not is_firing and is_spinning:
		spin_down()
	
	if is_firing and is_spinning:
		attempt_fire(delta)

func start_spinup() -> void:
	"""Start spinning up the minigun\"""
	is_spinning = true
	current_spin_progress = 0.0
	var spin_time = weapon_data.get("spin_up_time", 0.3)
	
	await get_tree().create_timer(spin_time).timeout
	current_spin_progress = 1.0

func spin_down() -> void:
	"""Spin down when not firing\"""
	is_spinning = false
	current_spin_progress = 0.0

func fire() -> void:
	"""Fire minigun while spinning\"""
	if ammo_in_magazine <= 0 or not is_spinning:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add significant spread at distance
	var spread_angle = randf_range(-2.0, 2.0)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func apply_recoil() -> void:
	"""Apply minigun recoil\"""
	var recoil = weapon_data.get("recoil", 0.3)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil) * 1.5)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["is_spinning"] = is_spinning
	info["spin_progress"] = current_spin_progress
	return info
