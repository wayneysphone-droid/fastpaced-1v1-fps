extends Node
class_name WeaponManager

# Weapon data
var weapon_data: Dictionary = {}
var weapon_classes: Dictionary = {}
var available_weapons: Array = []

# Player reference
var player: PlayerController = null
var current_weapon_index: int = 0
var loaded_weapons: Array = []

# Signals
signal weapon_switched(weapon_name: String)
signal weapon_unlocked(weapon_name: String)

func _ready() -> void:
	load_weapon_data()
	initialize_weapon_classes()

func load_weapon_data() -> void:
	"""Load weapon balance data from JSON"""
	var file = FileAccess.open("res://data/weapon_balance.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		json.parse(file.get_as_text())
		weapon_data = json.data.get("weapons", {})
		available_weapons = weapon_data.keys()

func initialize_weapon_classes() -> void:
	"""Setup weapon class mappings"""
	weapon_classes = {
		"sniper": preload("res://scripts/weapons/sniper.gd"),
		"shotgun": preload("res://scripts/weapons/shotgun.gd"),
		"assault_rifle": preload("res://scripts/weapons/assault_rifle.gd"),
		"burst_rifle": preload("res://scripts/weapons/burst_rifle.gd"),
		"minigun": preload("res://scripts/weapons/minigun.gd"),
		"flamethrower": preload("res://scripts/weapons/flamethrower.gd"),
		"rpg": preload("res://scripts/weapons/rpg.gd"),
		"grenade_launcher": preload("res://scripts/weapons/grenade_launcher.gd"),
		"bow": preload("res://scripts/weapons/bow.gd"),
		"crossbow": preload("res://scripts/weapons/crossbow.gd"),
		"paintball_gun": preload("res://scripts/weapons/paintball_gun.gd"),
		"distortion": preload("res://scripts/weapons/distortion.gd"),
		"energy_rifle": preload("res://scripts/weapons/energy_rifle.gd"),
		"gunblade": preload("res://scripts/weapons/gunblade.gd"),
		"permafrost": preload("res://scripts/weapons/permafrost.gd"),
	}

func create_weapon(weapon_key: String) -> WeaponBase:
	"""Create a weapon instance"""
	if weapon_key not in weapon_data:
		push_error("Weapon not found: " + weapon_key)
		return null
	
	var weapon_script = weapon_classes.get(weapon_key, WeaponBase)
	var weapon = weapon_script.new()
	weapon.load_weapon_data(weapon_data[weapon_key])
	
	return weapon

func equip_weapon(weapon_key: String) -> void:
	"""Equip a specific weapon"""
	var weapon = create_weapon(weapon_key)
	if weapon and player:
		if player.current_weapon:
			player.current_weapon.queue_free()
		
		player.add_child(weapon)
		weapon.position = Vector3(0.5, -0.3, -1.0)  # Right hand position
		player.set_weapon(weapon)
		current_weapon_index = available_weapons.find(weapon_key)
		weapon_switched.emit(weapon_key)

func switch_weapon(index: int) -> void:
	"""Switch to weapon at index"""
	if available_weapons.is_empty():
		return
	
	index = index % available_weapons.size()
	if index < 0:
		index = available_weapons.size() + index
	
	equip_weapon(available_weapons[index])

func get_weapon_info(weapon_key: String) -> Dictionary:
	"""Get information about a weapon"""
	return weapon_data.get(weapon_key, {})

func get_all_weapons() -> Array:
	"""Get list of all available weapons"""
	return available_weapons

func get_weapon_by_category(category: String) -> Array:
	"""Get all weapons in a category"""
	var result = []
	for key in available_weapons:
		if weapon_data[key].get("category") == category:
			result.append(key)
	return result

func get_damage_stats(weapon_key: String) -> Dictionary:
	"""Get damage statistics for a weapon"""
	var data = weapon_data.get(weapon_key, {})
	return {
		"base_damage": data.get("base_damage", 0),
		"headshot_multiplier": data.get("headshot_multiplier", 1.0),
		"dps": data.get("dps", data.get("base_damage", 0) / max(data.get("fire_rate", 1.0), 0.1))
	}

func get_handling_stats(weapon_key: String) -> Dictionary:
	"""Get handling statistics for a weapon"""
	var data = weapon_data.get(weapon_key, {})
	return {
		"fire_rate": data.get("fire_rate", 0.1),
		"reload_time": data.get("reload_time", 2.0),
		"magazine_size": data.get("magazine_size", 30),
		"accuracy": data.get("accuracy", 0.75),
		"recoil": data.get("recoil", 0.5),
		"movement_penalty": 1.0 - data.get("movement_speed_multiplier", 1.0)
	}

func set_player(player_node: PlayerController) -> void:
	"""Set the player this manager controls weapons for"""
	player = player_node