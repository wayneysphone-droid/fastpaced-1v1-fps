extends Node3D
class_name WeaponBase

# Weapon properties loaded from balance data
var weapon_data: Dictionary = {}
var weapon_name: String = ""
var weapon_type: String = ""

# Firing state
var is_firing: bool = false
var ammo_in_magazine: int = 0
var total_ammo: int = 999
var is_reloading: bool = false
var last_fire_time: float = 0.0

# References
var player_controller: Node3D = null
var muzzle_point: Node3D = null

# Signals
signal fired(origin: Vector3, direction: Vector3)
signal reloaded
signal ammo_changed
signal weapon_switched

func _ready() -> void:
	pass

func load_weapon_data(data: Dictionary) -> void:
	"""Load weapon configuration from balance data"""
	weapon_data = data
	weapon_name = data.get("name", "Unknown")
	weapon_type = data.get("type", "rifle")
	ammo_in_magazine = data.get("magazine_size", 30)

func _process(delta: float) -> void:
	if is_firing and not is_reloading:
		attempt_fire(delta)

func attempt_fire(delta: float) -> void:
	"""Attempt to fire the weapon based on fire rate"""
	var current_time = Time.get_ticks_msec() / 1000.0
	var fire_rate = weapon_data.get("fire_rate", 0.1)
	
	if current_time - last_fire_time >= fire_rate:
		if ammo_in_magazine > 0:
			fire()
		else:
			reload()

func fire() -> void:
	"""Fire the weapon"""
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z  # Forward direction
	
	fired.emit(origin, direction)
	
	ammo_changed.emit()
	
	# Apply recoil to player camera
	if player_controller:
		apply_recoil()

func apply_recoil() -> void:
	"""Apply weapon recoil to player camera"""
	var recoil = weapon_data.get("recoil", 0.5)
	if player_controller.has_method("add_camera_recoil"):
		var recoil_strength = randf_range(-recoil, recoil)
		player_controller.add_camera_recoil(recoil_strength * 2.0)

func reload() -> void:
	"""Reload the weapon"""
	if is_reloading or total_ammo <= 0:
		return
	
	is_reloading = true
	var reload_time = weapon_data.get("reload_time", 2.0)
	
	await get_tree().create_timer(reload_time).timeout
	
	var ammo_to_reload = weapon_data.get("magazine_size", 30) - ammo_in_magazine
	var actual_reload = min(ammo_to_reload, total_ammo)
	
	ammo_in_magazine += actual_reload
	total_ammo -= actual_reload
	is_reloading = false
	
	reloaded.emit()
	ammo_changed.emit()

func start_firing() -> void:
	"""Start continuous fire"""
	is_firing = true

func stop_firing() -> void:
	"""Stop continuous fire"""
	is_firing = false

func get_weapon_info() -> Dictionary:
	"""Return weapon information for UI"""
	return {
		"name": weapon_name,
		"type": weapon_type,
		"ammo_in_magazine": ammo_in_magazine,
		"total_ammo": total_ammo,
		"is_reloading": is_reloading,
		"magazine_size": weapon_data.get("magazine_size", 30)
	}

func apply_movement_modifier() -> float:
	"""Get movement speed modifier for this weapon"""
	return weapon_data.get("movement_speed_multiplier", 1.0)

func get_effective_range() -> float:
	"""Get effective range for this weapon"""
	return weapon_data.get("effective_range", 100.0)

func get_damage() -> float:
	"""Get base damage of this weapon"""
	return weapon_data.get("base_damage", 25)