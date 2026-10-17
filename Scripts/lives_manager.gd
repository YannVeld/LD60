class_name LivesManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

var lives_lost: int = 0:
	set(value):
		lives_lost = value
		if value < 0: 
			lives_lost = 0
		

var lives_left:
	get: return clamp(gameProperties.max_lives - lives_lost, 0, gameProperties.max_lives)

var bounces_since_fail: int = 0

var is_game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	lives_lost = 0

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
	print("Game over!")
	is_game_over = true
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



	
