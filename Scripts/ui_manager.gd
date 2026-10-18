class_name UIManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

@onready var livesManager: LivesManager = $"../LivesManager"
@onready var upgradeManager: UpgradeManager = $"../UpgradeManager"

@export var font: Font

@onready var _arrow_left: Texture2D = preload("res://Sprites/Arrow/Arrow_left.png")
@onready var _arrow_right: Texture2D = preload("res://Sprites/Arrow/Arrow_right.png")

@onready var _heart_full: Texture2D = preload("res://Sprites/Life_full.png")
@onready var _heart_empty: Texture2D = preload("res://Sprites/Life_empty.png")

var text_color: Color:
	get: return gameProperties.raw_color_palette.get_colors()[2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)
	livesManager.reset_game.connect(_on_game_reset)
	livesManager.can_restart_game.connect(_on_game_reset)
	upgradeManager.upgrade_applied.connect(_on_upgrade_applied)
	upgradeManager.description_changed.connect(_on_description_changed)
	upgradeManager.start_upgrading.connect(_on_start_upgrading)
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
	
func _on_description_changed():
	queue_redraw()
	
func _on_start_upgrading():
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
		draw_string(font, Vector2(16,32), "Bounces left for next life: " + str(gameProperties.bounce_count_for_life_gain - livesManager.bounces_since_fail), 0, -1, 16, text_color)	
		
		draw_string(font, Vector2(16,_height-16), "Score: " + str(ballManager.bat_bounce_count), 0, -1, 16, text_color)
	
	
		var _sep: float = 0.0
		var total_width = livesManager.lives_left * _heart_full.get_size().x\
			+ livesManager.lives_lost * _heart_empty.get_size().x\
			+ (livesManager.lives_left + livesManager.lives_lost - 1) * _sep
			
		var xoffset = center.x - total_width/2.0
		var ypos = 8.0
		for ii in range(livesManager.lives_left):
			draw_texture(_heart_full, Vector2(xoffset,ypos), text_color)
			xoffset += _heart_full.get_size().x + _sep
		for ii in range(livesManager.lives_lost):
			draw_texture(_heart_empty, Vector2(xoffset,ypos), text_color)
			xoffset += _heart_empty.get_size().x + _sep
	
	
	if upgradeManager._is_choosing:
		draw_string(font, center + Vector2(-_width/2.0,-64), "Choose one", HORIZONTAL_ALIGNMENT_CENTER, _width, 32, text_color)
		draw_string(font, center + Vector2(-_width/2.0,64), upgradeManager.selected_upgrade_description, HORIZONTAL_ALIGNMENT_CENTER, _width, 28, text_color)

	
	if livesManager.is_game_over:
		draw_string(font, center + Vector2(-_width/2,0), "Game Over!", HORIZONTAL_ALIGNMENT_CENTER, _width, 64, text_color)
		draw_string(font, center + Vector2(-_width/2,32), "Score: " + str(ballManager.bat_bounce_count), HORIZONTAL_ALIGNMENT_CENTER, _width, 28, text_color)

		if livesManager.can_restart:
			var ypos = 64
			var _text1: String = "<Press"
			var _text2: String = "or"
			var _text3: String = "to try again>"
			var _len1 = font.get_string_size(_text1, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
			var _len2 = font.get_string_size(_text2, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
			var _len3 = font.get_string_size(_text3, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
			var _arrow_len_left = _arrow_left.get_size().x
			var _arrow_len_right = _arrow_right.get_size().x
			var _total_len = _len1 + _len2 + _len3 + _arrow_len_left + _arrow_len_right
			
			var yoffset = _arrow_left.get_size().y/2.0 + 4.0
			
			
			var xoffset = -_total_len/2
			draw_string(font, center + Vector2(xoffset,ypos), _text1, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)
			xoffset += _len1
			draw_texture(_arrow_left, center + Vector2(xoffset,ypos - yoffset), text_color)
			xoffset += _arrow_len_left
			draw_string(font, center + Vector2(xoffset,ypos), _text2, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)
			xoffset += _len2
			draw_texture(_arrow_right, center + Vector2(xoffset,ypos - yoffset), text_color)
			xoffset += _arrow_len_right
			draw_string(font, center + Vector2(xoffset,ypos), _text3, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)


	if livesManager.waiting_to_begin:
		draw_string(font, center + Vector2(-_width/2,0), "Some Game Title", HORIZONTAL_ALIGNMENT_CENTER, _width, 64, text_color)
		
		var ypos = 64
		var _text1: String = "<Press"
		var _text2: String = "or"
		var _text3: String = ">"
		var _len1 = font.get_string_size(_text1, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
		var _len2 = font.get_string_size(_text2, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
		var _len3 = font.get_string_size(_text3, HORIZONTAL_ALIGNMENT_LEFT, _width, 16).x
		var _arrow_len_left = _arrow_left.get_size().x
		var _arrow_len_right = _arrow_right.get_size().x
		var _total_len = _len1 + _len2 + _len3 + _arrow_len_left + _arrow_len_right
		
		var yoffset = _arrow_left.get_size().y/2.0 + 4.0
		
		
		var xoffset = -_total_len/2
		draw_string(font, center + Vector2(xoffset,ypos), _text1, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)
		xoffset += _len1
		draw_texture(_arrow_left, center + Vector2(xoffset,ypos - yoffset), text_color)
		xoffset += _arrow_len_left
		draw_string(font, center + Vector2(xoffset,ypos), _text2, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)
		xoffset += _len2
		draw_texture(_arrow_right, center + Vector2(xoffset,ypos - yoffset), text_color)
		xoffset += _arrow_len_right
		draw_string(font, center + Vector2(xoffset,ypos), _text3, HORIZONTAL_ALIGNMENT_LEFT, _width, 16, text_color)
