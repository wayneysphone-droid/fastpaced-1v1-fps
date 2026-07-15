extends WeaponBase
class_name DistortionWeapon

# Distortion specific
var vortex_active: bool = false
var vortex_cooldown_remaining: float = 0.0
var max_vortex_duration: float = 4.0
var vortex_radius: float = 35.0

func _process(delta: float) -> void:
	super._process(delta)
	
	# Update vortex cooldown
	if vortex_cooldown_remaining > 0:
		vortex_cooldown_remaining -= delta

func fire() -> void:
	"""Fire distortion projectile"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add slight spread
	var spread_angle = randf_range(-3.0, 3.0)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	create_distortion_projectile(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_distortion_projectile(origin: Vector3, direction: Vector3) -> void:
	"""Create distortion projectile with splash damage"""
	var projectile_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 160.0),
		"damage": weapon_data.get("base_damage", 60),
		"splash_radius": weapon_data.get("splash_radius", 20.0),
		"lifetime": 8.0,
		"time_alive": 0.0,
		"can_vortex": true
	}

func create_vortex(position: Vector3) -> void:
	"""Create a vortex trap"""
	if vortex_cooldown_remaining > 0 or vortex_active:
		return
	
	vortex_active = true
	var vortex_info = {
		"position": position,
		"radius": weapon_data.get("vortex_radius", 35.0),
		"duration": weapon_data.get("vortex_duration", 4.0),
		"time_alive": 0.0,
		"pull_force": 50.0
	}
	
	vortex_cooldown_remaining = weapon_data.get("vortex_cooldown", 5.0)
	
	await get_tree().create_timer(max_vortex_duration).timeout
	vortex_active = false

func apply_recoil() -> void:
	"""Apply moderate recoil for distortion"""
	var recoil = weapon_data.get("recoil", 0.5)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil) * 0.8)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["vortex_active"] = vortex_active
	info["vortex_cooldown"] = vortex_cooldown_remaining
	return info
