class_name LivesManager extends Node2D

@export var gameProperties: GameProperties
@export var _start_game_sound: AudioStream
@export var _game_over_sound: AudioStream

@onready var ballManager: BallManager = $"../BallManager"
@onready var upgradeManager: UpgradeManager = $"../UpgradeManager"
@onready var _sound_manager: SoundManager = $"/root/Node2D/SoundManager"

signal reset_game
signal can_restart_game

var lives_lost: int = 0:
	set(value):
		lives_lost = value
		if value < 0: 
			lives_lost = 0
		

var lives_left:
	get: return clamp(gameProperties.max_lives - lives_lost, 0, gameProperties.max_lives)

var bounces_since_fail: int = 0

var is_game_over: bool = false
var waiting_to_begin: bool = true
var can_restart: bool = true

var game_over_pause_length: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	reset_game.connect(ballManager.reset)
	reset_game.connect(upgradeManager.reset)
	gameProperties.property_changed.connect(_on_max_life_reduced)
	lives_lost = 0
	
	gameProperties.initialize()
	get_tree().paused = true

func _on_max_life_reduced(property: String, new_value):
	if property != "max_lives": return
	lives_lost -= 1
	

func _on_out_of_bounds(out_of_bounds_count: int):
	bounces_since_fail = 0
	lives_lost += 1
	if lives_lost >= gameProperties.max_lives:
		_start_game_over()

func _on_bat_bounce(bat_bounce_count: int):
	bounces_since_fail += 1
	if bounces_since_fail >= gameProperties.bounce_count_for_life_gain:
		bounces_since_fail = 0
		lives_lost -= 1

func _start_game_over():
	is_game_over = true
	get_tree().paused = true
	_sound_manager.play_sound(_game_over_sound)
	
	can_restart = false
	await get_tree().create_timer(game_over_pause_length).timeout
	can_restart = true
	can_restart_game.emit()
	
func _reset_game():
	gameProperties.reset()
	reset_game.emit()
	bounces_since_fail = 0
	lives_lost = 0
	is_game_over = false
	waiting_to_begin = false
	get_tree().paused = false
	_sound_manager.play_sound(_start_game_sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (is_game_over or waiting_to_begin): return
	if not can_restart: return
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		_reset_game()



	
