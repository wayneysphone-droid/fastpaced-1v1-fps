extends WeaponBase
class_name CrossbowWeapon

# Crossbow specific
var projectile_count: int = 0

func fire() -> void:
	"""Fire crossbow bolt\"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add slight random spread
	var spread_angle = randf_range(-1.0, 1.0)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	create_bolt(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	projectile_count += 1
	
	if player_controller:
		apply_recoil()

func create_bolt(origin: Vector3, direction: Vector3) -> void:
	"""Create crossbow bolt projectile\"""
	var bolt_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 220.0),
		"damage": weapon_data.get("base_damage", 100),
		"lifetime": 8.0,
		"time_alive": 0.0
	}
	# TODO: Implement bolt physics

func apply_recoil() -> void:
	"""Apply light recoil for crossbow\"""
	var recoil = weapon_data.get("recoil", 0.3)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil * 0.5, recoil * 0.5))

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["projectiles_fired"] = projectile_count
	return info
