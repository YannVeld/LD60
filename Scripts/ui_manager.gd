class_name UIManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

@onready var livesManager: LivesManager = $"../LivesManager"
@onready var upgradeManager: UpgradeManager = $"../UpgradeManager"

@export var font: Font

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	livesManager.reset_game.connect(_on_game_reset)

func _on_out_of_bounds(out_of_bounds_count: int):
	queue_redraw()

func _on_bat_bounce(bat_bounce_count: int):
	queue_redraw()
	
func _on_game_reset():
	queue_redraw()

func _draw() -> void:
	draw_string(font, Vector2(16,16), "Lives left: " + str(livesManager.lives_left))
	draw_string(font, Vector2(16,32), "Bounces left for next life: " + str(gameProperties.bounce_count_for_life_gain - livesManager.bounces_since_fail))	
	
	var center: Vector2 = get_viewport_rect().size/2.0
	var _width: float = get_viewport_rect().size.x
	
	if livesManager.is_game_over:
		draw_string(font, center + Vector2(-_width/2,0), "Game Over!", HORIZONTAL_ALIGNMENT_CENTER, _width, 64)
		draw_string(font, center + Vector2(-_width/2,32), "<Press ← or → to try again>", HORIZONTAL_ALIGNMENT_CENTER, _width, 16)

	if livesManager.waiting_to_begin:
		draw_string(font, center + Vector2(-_width/2,0), "Some Game Title", HORIZONTAL_ALIGNMENT_CENTER, _width, 64)
		draw_string(font, center + Vector2(-_width/2,32), "<Press ← or →>", HORIZONTAL_ALIGNMENT_CENTER, _width, 16)
