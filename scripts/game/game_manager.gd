extends Node
class_name GameManager

# Match state
var player1: PlayerController = null
var player2: PlayerController = null
var is_match_active: bool = false
var match_time: float = 0.0
var max_match_time: float = 300.0  # 5 minutes

# Scoring
var player1_score: int = 0
var player2_score: int = 0
var match_winner: String = ""  # "player1", "player2", or "draw"

# Spawn points
var spawn_points: Array = []

# Signals
signal match_started
signal match_ended(winner: String)
signal player_died(player: PlayerController)
signal player_respawned(player: PlayerController)
signal score_updated(player1: int, player2: int)

func _ready() -> void:
	setup_spawn_points()

func _physics_process(delta: float) -> void:
	if is_match_active:
		update_match_time(delta)

func start_match() -> void:
	"""Start a new 1v1 match"""
	is_match_active = true
	match_time = 0.0
	player1_score = 0
	player2_score = 0
	match_winner = ""
	
	# Respawn both players
	if player1:
		respawn_player(player1, 0)
	if player2:
		respawn_player(player2, 1)
	
	match_started.emit()

func end_match(winner: String) -> void:
	"""End the current match"""
	is_match_active = false
	match_winner = winner
	match_ended.emit(winner)

func update_match_time(delta: float) -> void:
	"""Update match timer"""
	match_time += delta
	
	if match_time >= max_match_time:
		end_match(determine_winner())

func handle_player_death(deceased: PlayerController) -> void:
	"""Handle a player death"""
	player_died.emit(deceased)
	
	# Determine which player died
	if deceased == player1:
		player2_score += 1
	else:
		player1_score += 1
	
	score_updated.emit(player1_score, player2_score)
	
	# Respawn after delay
	await get_tree().create_timer(3.0).timeout
	
	if deceased == player1:
		respawn_player(player1, 0)
	else:
		respawn_player(player2, 1)

func respawn_player(player: PlayerController, spawn_index: int) -> void:
	"""Respawn a player at their spawn point"""
	if spawn_index < spawn_points.size():
		var spawn_pos = spawn_points[spawn_index]
		player.respawn(spawn_pos)
		player_respawned.emit(player)

func setup_spawn_points() -> void:
	"""Setup spawn points for players"""
	# TODO: Load from map or define spawn points
	spawn_points = [
		Vector3(-10, 1, 0),  # Player 1 spawn
		Vector3(10, 1, 0)     # Player 2 spawn
	]

func determine_winner() -> String:
	"""Determine match winner based on score"""
	if player1_score > player2_score:
		return "player1"
	elif player2_score > player1_score:
		return "player2"
	else:
		return "draw"

func get_match_info() -> Dictionary:
	"""Get current match information"""
	return {
		"is_active": is_match_active,
		"time": match_time,
		"max_time": max_match_time,
		"player1_score": player1_score,
		"player2_score": player2_score,
		"player1_health": player1.current_health if player1 else 0,
		"player2_health": player2.current_health if player2 else 0
	}
