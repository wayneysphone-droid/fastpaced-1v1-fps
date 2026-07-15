extends WeaponBase
class_name PermafrostWeapon

# Permafrost specific
var freeze_level: float = 0.0
var freeze_per_shot: float = 15.0

func fire() -> void:
	"""Fire permafrost rifle with freeze effect"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add slight spread
	var spread_angle = randf_range(-1.5, 1.5)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	create_ice_projectile(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_ice_projectile(origin: Vector3, direction: Vector3) -> void:
	"""Create ice projectile with freeze effect"""
	var projectile_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("bullet_speed", 270.0),
		"damage": weapon_data.get("base_damage", 28),
		"freeze_duration": weapon_data.get("freeze_duration", 2.0),
		"slow_percentage": weapon_data.get("slow_percentage", 0.4),
		"lifetime": 7.0,
		"time_alive": 0.0
	}

func apply_freeze_effect(target: Node, duration: float, slow_percent: float) -> void:
	"""Apply freeze effect to target"""
	if target.has_method("apply_slow"):
		target.apply_slow(slow_percent, duration)

func apply_recoil() -> void:
	"""Apply moderate recoil for permafrost"""
	var recoil = weapon_data.get("recoil", 0.45)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil) * 0.9)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["freeze_level"] = freeze_level
	return info
