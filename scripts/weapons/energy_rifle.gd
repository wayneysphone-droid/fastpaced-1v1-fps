extends WeaponBase
class_name EnergyRifleWeapon

# Energy rifle specific
var heat_level: float = 0.0
var max_heat: float = 100.0
var heat_per_shot: float = 15.0
var overheat_cooldown: float = 2.0
var is_overheated: bool = false

func _process(delta: float) -> void:
	super._process(delta)
	
	# Cool down heat over time
	if not is_firing:
		heat_level = max(heat_level - delta * 30.0, 0.0)
		if is_overheated and heat_level < max_heat * 0.5:
			is_overheated = false

func fire() -> void:
	"""Fire energy rifle with heat management"""
	if ammo_in_magazine <= 0 or is_overheated:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	# Add heat
	heat_level += heat_per_shot
	if heat_level >= max_heat:
		is_overheated = true
		heat_level = max_heat
		await get_tree().create_timer(overheat_cooldown).timeout
		is_overheated = false
		heat_level = max_heat * 0.5
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Slight accuracy bonus
	var spread_angle = randf_range(-0.5, 0.5)
	var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
	direction = spread_rotation * direction
	
	create_laser(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_laser(origin: Vector3, direction: Vector3) -> void:
	"""Create laser projectile"""
	var laser_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("bullet_speed", 400.0),
		"damage": weapon_data.get("base_damage", 30),
		"lifetime": 5.0,
		"time_alive": 0.0
	}

func apply_recoil() -> void:
	"""Apply minimal recoil for energy rifle"""
	var recoil = weapon_data.get("recoil", 0.2)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil) * 0.5)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["heat_level"] = heat_level
	info["max_heat"] = max_heat
	info["is_overheated"] = is_overheated
	return info
