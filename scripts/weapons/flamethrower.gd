extends WeaponBase
class_name FlamethrowerWeapon

# Flamethrower specific
var is_burning: bool = false
var burn_instances: Array = []
var max_active_burns: int = 5

func _process(delta: float) -> void:
	if is_firing:
		perform_flame_burst()
	
	# Clean up expired burn effects
	for i in range(burn_instances.size() - 1, -1, -1):
		if burn_instances[i]["time_remaining"] <= 0:
			burn_instances.remove_at(i)

func perform_flame_burst() -> void:
	"""Create a burst of flame damage\"""
	var current_time = Time.get_ticks_msec() / 1000.0
	var fire_rate = weapon_data.get("fire_rate", 0.15)
	
	if current_time - last_fire_time >= fire_rate:
		if ammo_in_magazine > 0:
			fire()
		else:
			reload()

func fire() -> void:
	"""Fire flame burst\"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	var range_val = weapon_data.get("range", 25.0)
	
	# Create multiple flame rays
	for i in range(3):
		var spread_angle = randf_range(-15.0, 15.0)
		var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
		var flame_direction = spread_rotation * direction
		
		create_flame_ray(origin, flame_direction, range_val)
	
	fired.emit(origin, direction)
	ammo_changed.emit()

func create_flame_ray(origin: Vector3, direction: Vector3, range_val: float) -> void:
	"""Create a flame ray projectile\"""
	var flame_info = {
		"origin": origin,
		"direction": direction.normalized(),
		"range": range_val,
		"damage": weapon_data.get("base_damage", 12),
		"dps": weapon_data.get("dps", 60),
		"time_remaining": weapon_data.get("fire_duration", 3.0)
	}
	
	if burn_instances.size() < max_active_burns:
		burn_instances.append(flame_info)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["active_flames"] = burn_instances.size()
	return info
