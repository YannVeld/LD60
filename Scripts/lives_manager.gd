class_name LivesManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

var font: Font = preload("res://Fonts/m6x11.ttf")

var lives_lost: int = 0:
	set(value):
		lives_lost = value
		if value < 0: 
			lives_lost = 0
		

var lives_left:
	get: return clamp(gameProperties.max_lives - lives_lost, 0, gameProperties.max_lives)

var bounces_since_fail: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	lives_lost = 0

func _on_out_of_bounds(out_of_bounds_count: int):
	bounces_since_fail = 0
	lives_lost += 1
	if lives_lost >= gameProperties.max_lives:
		print("Game over!")
	
	queue_redraw()

func _on_bat_bounce(bat_bounce_count: int):
	bounces_since_fail += 1
	if bounces_since_fail >= gameProperties.bounce_count_for_life_gain:
		bounces_since_fail = 0
		lives_lost -= 1
	
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	draw_string(font, Vector2(16,16), "Lives left: " + str(lives_left))
	draw_string(font, Vector2(16,32), "Bounces left for next life: " + str(gameProperties.bounce_count_for_life_gain - bounces_since_fail))	
	
	
