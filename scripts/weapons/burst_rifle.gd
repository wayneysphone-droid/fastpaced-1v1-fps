extends WeaponBase
class_name BurstRifleWeapon

# Burst rifle specific
var burst_count: int = 3
var burst_interval: float = 0.05
var bullets_fired_in_burst: int = 0
var is_in_burst: bool = false

func fire() -> void:
	"""Fire burst rifle with 3-round burst"""
	if ammo_in_magazine <= 0:
		return
	
	if is_in_burst:
		return
	
	is_in_burst = true
	bullets_fired_in_burst = 0
	
	for i in range(burst_count):
		if ammo_in_magazine <= 0:
			break
		
		ammo_in_magazine -= 1
		bullets_fired_in_burst += 1
		
		var origin = global_position
		var direction = -global_transform.basis.z
		
		# Add slight spread per bullet in burst
		var spread_angle = randf_range(-0.5, 0.5) * i
		var spread_rotation = Basis.from_euler(Vector3(spread_angle * PI / 180.0, 0, 0))
		direction = spread_rotation * direction
		
		fired.emit(origin, direction)
		
		if player_controller:
			apply_recoil()
		
		if i < burst_count - 1:
			await get_tree().create_timer(burst_interval).timeout
	
	last_fire_time = Time.get_ticks_msec() / 1000.0
	ammo_changed.emit()
	
	await get_tree().create_timer(weapon_data.get("fire_rate", 0.4)).timeout
	is_in_burst = false

func apply_recoil() -> void:
	"""Apply controlled recoil for burst rifle"""
	var recoil = weapon_data.get("recoil", 0.4)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil * 0.8, recoil * 0.8))
