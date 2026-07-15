extends Node3D
class_name ProjectileHandler

# Projectile tracking
var active_projectiles: Array = []
var max_projectiles: int = 256

# Physics
var gravity: float = 25.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Update all active projectiles
	for i in range(active_projectiles.size() - 1, -1, -1):
		var projectile = active_projectiles[i]
		update_projectile(projectile, delta)
		
		if projectile["time_alive"] >= projectile["lifetime"]:
			active_projectiles.remove_at(i)

func update_projectile(projectile: Dictionary, delta: float) -> void:
	"""Update a single projectile's position and check for hits"""
	projectile["time_alive"] += delta
	
	# Apply gravity if enabled
	if projectile.get("gravity_enabled", false):
		projectile["velocity"].y -= gravity * delta
	
	# Update position
	projectile["position"] += projectile["velocity"] * delta
	
	# Check for collisions (raycast)
	check_projectile_collision(projectile)

func create_projectile(origin: Vector3, direction: Vector3, damage: float, speed: float, lifetime: float = 10.0, projectile_type: String = "bullet") -> void:
	"""Create a new projectile"""
	if active_projectiles.size() >= max_projectiles:
		return
	
	var projectile = {
		"position": origin,
		"velocity": direction.normalized() * speed,
		"damage": damage,
		"lifetime": lifetime,
		"time_alive": 0.0,
		"type": projectile_type,
		"gravity_enabled": projectile_type in ["grenade", "rocket"],
		"owner": null
	}
	
	active_projectiles.append(projectile)

func check_projectile_collision(projectile: Dictionary) -> void:
	"""Check if projectile hit anything"""
	# TODO: Implement raycast/collision detection
	# This would check against player hitboxes and environment
	pass

func apply_damage(target: Node, damage: float, hit_type: String = "body") -> void:
	"""Apply damage to a target"""
	if target.has_method("take_damage"):
		target.take_damage(damage, hit_type)

func get_active_projectile_count() -> int:
	"""Get number of active projectiles"""
	return active_projectiles.size()
