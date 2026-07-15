extends WeaponBase
class_name BowWeapon

# Bow specific
var is_charging: bool = false
var charge_progress: float = 0.0
var max_charge_time: float = 1.5
var has_extra_jump: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if not is_charging and not is_reloading:
			start_charge()
		
		if is_charging:
			update_charge(delta)
	elif is_charging:
		fire()

func start_charge() -> void:
	"""Start charging the bow\"""
	is_charging = true
	charge_progress = 0.0

func update_charge(delta: float) -> void:
	"""Update charge progress\"""
	charge_progress = min(charge_progress + delta / max_charge_time, 1.0)

func fire() -> void:
	"""Fire the bow\"""
	if ammo_in_magazine <= 0:
		is_charging = false
		return
	
	ammo_in_magazine -= 1
	last_fire_time = Time.get_ticks_msec() / 1000.0
	
	var origin = global_position
	var direction = -global_transform.basis.z
	
	# Damage scales with charge
	var damage = weapon_data.get("base_damage", 80)
	var max_damage = weapon_data.get("max_charge_damage", 150)
	var final_damage = lerp(damage * 0.5, max_damage, charge_progress)
	
	create_arrow(origin, direction, final_damage)
	
	# Grant extra jump if fully charged
	if charge_progress >= 0.95 and player_controller:
		grant_extra_jump()
	
	fired.emit(origin, direction)
	ammo_changed.emit()
	is_charging = false
	charge_progress = 0.0
	
	if player_controller:
		apply_recoil()

func create_arrow(origin: Vector3, direction: Vector3, damage: float) -> void:
	"""Create arrow projectile\"""
	var arrow_info = {
		"position": origin,
		"velocity": direction.normalized() * weapon_data.get("projectile_speed", 200.0),
		"damage": damage,
		"lifetime": 10.0,
		"time_alive": 0.0
	}
	# TODO: Implement arrow physics

func grant_extra_jump() -> void:
	"""Grant player extra jump\"""
	if player_controller and player_controller.has_method("grant_extra_jump"):
		player_controller.grant_extra_jump()
	has_extra_jump = true

func get_weapon_info() -> Dictionary:
	var info = super.get_weapon_info()
	info["is_charging"] = is_charging
	info["charge_progress"] = charge_progress
	info["current_damage"] = weapon_data.get("base_damage", 80) if charge_progress < 0.5 else weapon_data.get("max_charge_damage", 150)
	return info
