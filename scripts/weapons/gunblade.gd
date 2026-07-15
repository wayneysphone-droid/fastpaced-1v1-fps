extends WeaponBase
class_name GunbladeWeapon

# Gunblade specific
var current_mode: String = "ranged"  # "ranged" or "melee"
var melee_range: float = 6.0
var is_in_melee: bool = false
var melee_cooldown: float = 0.5
var last_melee_time: float = -999.0

func _process(delta: float) -> void:
	super._process(delta)
	
	# Handle melee attacks
	if Input.is_action_just_pressed("melee"):
		perform_melee_attack()

func fire() -> void:
	"""Fire gunblade projectile"""
	if current_mode != "ranged" or ammo_in_magazine <= 0:
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	create_gunblade_projectile(origin, direction)
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	
	if player_controller:
		apply_recoil()

func create_gunblade_projectile(origin: Vector3, direction: Vector3) -> void:
	"""Create gunblade projectile"""
	var projectile_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 180.0),
		"damage": weapon_data.get("projectile_damage", 45),
		"lifetime": 5.0,
		"time_alive": 0.0
	}


func perform_melee_attack() -> void:
	"""Perform melee slash"""
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_melee_time < melee_cooldown:
		return
	
	last_melee_time = current_time
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	var melee_damage = weapon_data.get("melee_damage", 120)
	
	fired.emit(origin, direction)
	
	# Switch to ranged mode after melee
	if weapon_data.get("mode_switch_on_hit", false):
		current_mode = "ranged" if current_mode == "melee" else "melee"

func apply_recoil() -> void:
	"""Apply light recoil for gunblade ranged mode"""
	var recoil = weapon_data.get("recoil", 0.3)
	if player_controller and player_controller.has_method("add_camera_recoil"):
		player_controller.add_camera_recoil(randf_range(-recoil, recoil) * 0.6)

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["current_mode"] = current_mode
	info["melee_cooldown"] = max(0, melee_cooldown - (Time.get_ticks_msec() / 1000.0 - last_melee_time))
	return info
