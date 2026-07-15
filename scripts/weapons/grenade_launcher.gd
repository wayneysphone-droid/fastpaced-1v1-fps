extends WeaponBase
class_name GrenadeLauncherWeapon

# Grenade launcher specific
var projectiles: Array = []
var max_projectiles: int = 8

func fire() -> void:
	"""Fire grenade launcher\"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add slight upward angle for arc
	direction = direction.rotated(Vector3.RIGHT, -0.1)
	
	create_grenade(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_grenade(origin: Vector3, direction: Vector3) -> void:
	"""Create a grenade projectile with physics\"""
	var grenade_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 120.0),
		"gravity": Vector3(0, -25.0, 0),
		"damage": weapon_data.get("base_damage", 120),
		"radius": weapon_data.get("impact_radius", 25.0),
		"bounce_count": weapon_data.get("bounce_count", 3),
		"bounces_remaining": weapon_data.get("bounce_count", 3),
		"lifetime": 10.0,
		"time_alive": 0.0,
		"detonated": false
	}
	
	if projectiles.size() < max_projectiles:
		projectiles.append(grenade_info)

func apply_recoil() -> void:
	"""Apply moderate recoil for grenade launcher\"""
	var recoil = weapon_data.get("recoil", 0.4)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil))

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["active_grenades"] = projectiles.size()
	return info
