class_name UIManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

@onready var livesManager: LivesManager = $"../LivesManager"
@onready var upgradeManager: UpgradeManager = $"../UpgradeManager"

@export var font: Font

var text_color: Color:
	get: return gameProperties.raw_color_palette.get_colors()[2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	livesManager.reset_game.connect(_on_game_reset)
	upgradeManager.upgrade_applied.connect(_on_upgrade_applied)
	gameProperties.property_changed.connect(_on_property_changed)
	
	_set_background_color(gameProperties.color_palette)

func _on_out_of_bounds(out_of_bounds_count: int):
	queue_redraw()

func _on_bat_bounce(bat_bounce_count: int):
	queue_redraw()
	
func _on_game_reset():
	queue_redraw()
	
func _on_upgrade_applied():
	queue_redraw()
	
func _on_property_changed(property: String, new_value):
	if property != "color_palette": return
	_set_background_color(gameProperties.color_palette)
	
func _set_background_color(palette: ColorPalette):
	RenderingServer.set_default_clear_color(palette.get_colors()[0])

func _draw() -> void:
	var center: Vector2 = get_viewport_rect().size/2.0
	var _width: float = get_viewport_rect().size.x
	var _height: float = get_viewport_rect().size.y
	
	if not livesManager.waiting_to_begin:
		draw_string(font, Vector2(16,16), "Lives left: " + str(livesManager.lives_left), 0, -1, 16, text_color)
		draw_string(font, Vector2(16,32), "Bounces left for next life: " + str(gameProperties.bounce_count_for_life_gain - livesManager.bounces_since_fail), 0, -1, 16, text_color)	
		
		draw_string(font, Vector2(16,_height-16), "Score: " + str(ballManager.bat_bounce_count), 0, -1, 16, text_color)
	

	
	if livesManager.is_game_over:
		draw_string(font, center + Vector2(-_width/2,0), "Game Over!", HORIZONTAL_ALIGNMENT_CENTER, _width, 64, text_color)
		draw_string(font, center + Vector2(-_width/2,32), "Score: " + str(ballManager.bat_bounce_count), HORIZONTAL_ALIGNMENT_CENTER, _width, 28, text_color)
		draw_string(font, center + Vector2(-_width/2,64), "<Press ← or → to try again>", HORIZONTAL_ALIGNMENT_CENTER, _width, 16, text_color)

	if livesManager.waiting_to_begin:
		draw_string(font, center + Vector2(-_width/2,0), "Some Game Title", HORIZONTAL_ALIGNMENT_CENTER, _width, 64, text_color)
		draw_string(font, center + Vector2(-_width/2,32), "<Press ← or →>", HORIZONTAL_ALIGNMENT_CENTER, _width, 16, text_color)
