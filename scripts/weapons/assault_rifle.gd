extends WeaponBase
class_name AssaultRifleWeapon

# Assault rifle specific
var recoil_accumulation: float = 0.0
var max_recoil: float = 1.5

func _process(delta: float) -> void:
	super._process(delta)
	
	# Decay recoil over time
	recoil_accumulation = lerp(recoil_accumulation, 0.0, 0.1)

func fire() -> void:
	"""Fire with assault rifle mechanics"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Add recoil to shot direction
	recoil_accumulation = min(recoil_accumulation + 0.05, max_recoil)
	var recoil_angle = randf_range(-recoil_accumulation, recoil_accumulation) * 0.1
	
	# Create spread
	var spread_vector = Vector3.ONE * recoil_angle
	direction = (direction + spread_vector).normalized()
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func apply_recoil() -> void:
	"""Apply recoil with accumulation"""
	var recoil = weapon_data.get("recoil", 0.5)
	if player_controller.has_method("add_camera_recoil"):
		var recoil_strength = recoil * (1.0 + recoil_accumulation * 0.3)
		player_controller.add_camera_recoil(recoil_strength)