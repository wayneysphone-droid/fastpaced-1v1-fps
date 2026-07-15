extends WeaponBase
class_name PaintballGunWeapon

# Paintball gun specific
var tracked_targets: Dictionary = {}

func fire() -> void:
	"""Fire paintball"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add light spread
	var spread_angle = randf_range(-2.0, 2.0)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	create_paintball(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()

func create_paintball(origin: Vector3, direction: Vector3) -> void:
	"""Create paintball projectile that tracks enemies"""
	var paintball_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("bullet_speed", 200.0),
		"damage": weapon_data.get("base_damage", 8),
		"lifetime": 6.0,
		"time_alive": 0.0,
		"tracking_duration": weapon_data.get("tracking_duration", 8.0)
	}

func apply_tracking(target: Node) -> void:
	"""Apply tracking effect to target"""
	var tracking_duration = weapon_data.get("tracking_duration", 8.0)
	tracked_targets[target] = {
		"duration": tracking_duration,
		"painted": true
	}

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["tracked_targets"] = tracked_targets.size()
	return info
