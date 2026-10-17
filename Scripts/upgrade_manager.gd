class_name UpgradeManager extends Node2D

@export var gameProperties: GameProperties

@onready var ballManager: BallManager = $"../BallManager"

var font: Font = preload("res://Fonts/m6x11.ttf")

var _previous_choice_bounce_count: int = 0
var _is_choosing: bool = false

var _buttons: Array[UpgradeButton] = []


const KEY_TO_INDEX: Dictionary[Key, int] = {
	KEY_1: 1,
	KEY_2: 2,
	KEY_3: 3,
	KEY_4: 4,
	KEY_5: 5,
	KEY_6: 6,
	KEY_7: 7,
	KEY_8: 8,
	KEY_9: 9
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)

	for _button in get_children():
		if not _button is Button: continue
		_buttons.append(_button)
		
	for _button: UpgradeButton in _buttons:
		_button.pressed_upgrade.connect(_on_upgrade_button_pressed)
		_button.hide()


func _on_out_of_bounds(out_of_bounds_count: int):
	queue_redraw()
	
func _on_bat_bounce(bat_bounce_count: int):
	queue_redraw()
	
	
func _present_upgrade_choice():
	if _is_choosing: return
	
	_previous_choice_bounce_count = ballManager.bat_bounce_count
	_is_choosing = true
	get_tree().paused = true
	
	for _button: UpgradeButton in _buttons:
		_button.show()

func _apply_upgrade(index: int):
	print("Applied upgrade "+str(index))
	_close_upgrade_choice()

func _close_upgrade_choice():
	for _button: Button in _buttons:
		_button.hide()
		
	_is_choosing = false
	get_tree().paused = false


func _on_upgrade_button_pressed(index: int):
	_apply_upgrade(index)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _next_count: int = _previous_choice_bounce_count + gameProperties.bounces_between_choices
	if ballManager.bat_bounce_count >= _next_count:
		_present_upgrade_choice()


func _draw() -> void:
	draw_string(font, Vector2(16,16), "Bounces: " + str(ballManager.bat_bounce_count))
	draw_string(font, Vector2(16,32), "Fails: " + str(ballManager.out_of_bounds_count))
	
func _input(event):
	if not event is InputEventKey: return
	if not event.pressed: return
	if not _is_choosing: return
	if not event.keycode in KEY_TO_INDEX.keys(): return
	
	var _index = KEY_TO_INDEX[event.keycode] - 1
	if _index >= gameProperties.upgrade_option_count: return
	
	_apply_upgrade(_index)
