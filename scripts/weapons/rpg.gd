extends WeaponBase
class_name RPGWeapon

# RPG specific
var projectile_scene: PackedScene = null
var max_active_rockets: int = 4
var active_rockets: Array = []

func fire() -> void:
	"""Fire RPG rocket\"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	create_rocket(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_rocket(origin: Vector3, direction: Vector3) -> void:
	"""Create an RPG rocket projectile\"""
	var rocket_info = {
		"position": origin,
		"direction": direction.normalized(),
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 150.0),
		"damage": weapon_data.get("base_damage", 200),
		"radius": weapon_data.get("impact_radius", 30.0),
		"lifetime": weapon_data.get("projectile_lifetime", 10.0),
		"time_alive": 0.0
	}
	
	if active_rockets.size() < max_active_rockets:
		active_rockets.append(rocket_info)

func apply_recoil() -> void:
	"""Apply strong recoil for RPG\"""
	var recoil = weapon_data.get("recoil", 0.5)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil * 1.5, recoil * 1.5))

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["active_rockets"] = active_rockets.size()
	return info
