extends WeaponBase
class_name ShotgunWeapon

# Shotgun specific
var pellets: int = 8
var pellet_spread: float = 15.0

func fire() -> void:
	"""Fire shotgun with multiple pellets"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var base_direction = -global_transform.basis.z
	
	# Fire multiple pellets with spread
	for i in range(pellets):
		var angle_x = randf_range(-pellet_spread, pellet_spread)
		var angle_y = randf_range(-pellet_spread, pellet_spread)
		
		var spread_rotation = Basis.from_euler(Vector3(
			angle_x * PI / 180.0,
			angle_y * PI / 180.0,
			0
		))
		
		var pellet_direction = spread_rotation * base_direction
		
		# Create pellet projectile
		create_pellet(origin, pellet_direction)
	
	fired.emit(origin, base_direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_pellet(origin: Vector3, direction: Vector3) -> void:
	"""Create a pellet projectile"""
	# TODO: Implement actual projectile system
	# Placeholder
	pass

func apply_recoil() -> void:
	"""Apply strong recoil for shotgun"""
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-1.5, 1.5))