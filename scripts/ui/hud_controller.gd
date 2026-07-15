extends CanvasLayer
class_name HUDController

# References
var player: PlayerController = null
var weapon_manager: WeaponManager = null
var game_manager: GameManager = null

# UI Elements (to be created in scenes)
var health_label: Label = null
var ammo_label: Label = null
var weapon_label: Label = null
var timer_label: Label = null
var score_label: Label = null

func _ready() -> void:
	create_ui_elements()

func _process(_delta: float) -> void:
	update_hud()

func create_ui_elements() -> void:
	"""Create UI elements programmatically"""
	# Health label
	health_label = Label.new()
	add_child(health_label)
	health_label.position = Vector2(20, 20)
	health_label.add_theme_font_size_override("font_size", 24)
	
	# Ammo label
	ammo_label = Label.new()
	add_child(ammo_label)
	ammo_label.position = Vector2(20, 60)
	ammo_label.add_theme_font_size_override("font_size", 20)
	
	# Weapon label
	weapon_label = Label.new()
	add_child(weapon_label)
	weapon_label.position = Vector2(20, 100)
	weapon_label.add_theme_font_size_override("font_size", 18)
	
	# Timer label
	timer_label = Label.new()
	add_child(timer_label)
	timer_label.position = Vector2(Screen.get_size().x / 2 - 50, 20)
	timer_label.add_theme_font_size_override("font_size", 24)
	
	# Score label
	score_label = Label.new()
	add_child(score_label)
	score_label.position = Vector2(Screen.get_size().x - 200, 20)
	score_label.add_theme_font_size_override("font_size", 20)

func update_hud() -> void:
	"""Update all HUD elements"""
	if player:
		update_health_display()
		update_ammo_display()
		update_weapon_display()
	
	if game_manager:
		update_timer_display()
		update_score_display()

func update_health_display() -> void:
	"""Update health display"""
	if health_label:
		health_label.text = "HP: %.0f / %.0f" % [player.current_health, player.max_health]

func update_ammo_display() -> void:
	"""Update ammo display"""
	if ammo_label and player.current_weapon:
		var weapon_info = player.current_weapon.get_weapon_info()
		ammo_label.text = "Ammo: %d / %d" % [weapon_info["ammo_in_magazine"], weapon_info["total_ammo"]]

func update_weapon_display() -> void:
	"""Update weapon name display"""
	if weapon_label and player.current_weapon:
		weapon_label.text = "Weapon: %s" % player.current_weapon.weapon_name

func update_timer_display() -> void:
	"""Update match timer"""
	if timer_label:
		var minutes = int(game_manager.match_time) / 60
		var seconds = int(game_manager.match_time) % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_score_display() -> void:
	"""Update score display"""
	if score_label:
		score_label.text = "Score: %d - %d" % [game_manager.player1_score, game_manager.player2_score]

func show_kill_notification(killer: String, victim: String) -> void:
	"""Show a kill notification"""
	print("%s killed %s" % [killer, victim])

func set_player(player_node: PlayerController) -> void:
	"""Set the player this HUD displays for"""
	player = player_node

func set_game_manager(manager: GameManager) -> void:
	"""Set the game manager reference"""
	game_manager = manager
