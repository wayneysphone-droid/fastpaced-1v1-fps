extends Node
class_name DamageCalculator

func calculate_damage(base_damage: float, hit_location: String, weapon_data: Dictionary) -> float:
	"""Calculate final damage based on hit location"""
	var multiplier = get_damage_multiplier(hit_location)
	var final_damage = base_damage * multiplier
	
	# Apply armor reduction if applicable
	if weapon_data.get("armor_piercing", false):
		return final_damage
	
	return final_damage

func get_damage_multiplier(hit_location: String) -> float:
	"""Get damage multiplier for hit location"""
	match hit_location:
		"headshot":
			return 1.5
		"body":
			return 1.0
		"limbs":
			return 0.75
		_:
			return 1.0

func is_lethal(damage: float, target_health: float) -> bool:
	"""Check if damage would be lethal"""
	return damage >= target_health

func calculate_falloff(base_damage: float, distance: float, max_range: float) -> float:
	"""Calculate damage with distance falloff"""
	if distance > max_range:
		return 0.0
	
	var falloff_ratio = distance / max_range
	return base_damage * (1.0 - falloff_ratio * 0.5)
