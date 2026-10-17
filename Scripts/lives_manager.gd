class_name LivesManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

signal reset_game

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	reset_game.connect(ballManager.reset)
	lives_lost = 0
	
	gameProperties.initialize()
	get_tree().paused = true

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
	
func _reset_game():
	gameProperties.reset()
	reset_game.emit()
	bounces_since_fail = 0
	lives_lost = 0
	is_game_over = false
	waiting_to_begin = false
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (is_game_over or waiting_to_begin): return
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		_reset_game()



	
