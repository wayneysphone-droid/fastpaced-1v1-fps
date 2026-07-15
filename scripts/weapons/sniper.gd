extends WeaponBase
class_name SniperWeapon

# Sniper specific
var is_scoped: bool = false
var scope_zoom: float = 4.0
var min_zoom: float = 1.0
var max_zoom: float = 8.0
var current_zoom: float = 1.0

func _process(delta: float) -> void:
	super._process(delta)
	
	# Handle zoom
	if Input.is_action_just_pressed("scope"):
		toggle_scope()

func toggle_scope() -> void:
	"""Toggle scope zoom"""
	is_scoped = !is_scoped
	if is_scoped:
		current_zoom = scope_zoom
	else:
		current_zoom = 1.0

func fire() -> void:
	"""Fire with sniper mechanics"""
	if ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Create sniper projectile with high speed
	create_sniper_shot(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_sniper_shot(origin: Vector3, direction: Vector3) -> void:
	"""Create a sniper shot projectile"""
	# TODO: Implement actual projectile/raycast system
	# This is a placeholder for the sniper bullet
	var damage = weapon_data.get("base_damage", 150)
	var headshot_mult = weapon_data.get("headshot_multiplier", 2.5)
	
	print("Sniper shot fired: %.0f damage, %.1fx headshot" % [damage, headshot_mult])

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["is_scoped"] = is_scoped
	info["current_zoom"] = current_zoom
	return info