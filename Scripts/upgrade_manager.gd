class_name UpgradeManager extends Node2D

@export var gameProperties: GameProperties
@onready var ballManager: BallManager = $"../BallManager"

@export var possible_upgrades: Array[Upgrade] = []

signal upgrade_applied
var _upgrade_button := preload("res://Scenes/upgrade_button.tscn")

var _previous_choice_bounce_count: int = 0
var _is_choosing: bool = false

var _buttons: Array[UpgradeButton] = []
var option_count: int:
	get: return _buttons.size()

var _upgrades: Array[Upgrade] = []

const BUTTON_SPACING: float = 64.0

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

var _button_selected: int = -1

signal description_changed
var selected_upgrade_description: String:
	get:
		if _button_selected < 0: return ""
		if _button_selected >= option_count: return ""
		return _upgrades[_button_selected].description

func reset():
	_previous_choice_bounce_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameProperties.property_changed.connect(_on_upgrade_option_count_changed)

	for ii in range(gameProperties.upgrade_option_count):
		_create_button()
		
	_roll_new_upgrades()
	

func _create_button():
	var _inst: UpgradeButton = _upgrade_button.instantiate()
	var center: Vector2 = get_viewport_rect().size/2.0
	_inst.global_position = center
	_inst.index = option_count
	#_inst.text = str(option_count + 1)
	add_child(_inst)

	_inst.pressed_upgrade.connect(_on_upgrade_button_pressed)
	_inst.mouse_entered_upgrade.connect(_on_upgrade_button_mouse_entered)
	_inst.mouse_exited_upgrade.connect(_on_upgrade_button_mouse_exited)
	_buttons.append(_inst)
	
	_inst.hide()
	
func _remove_button():
	var _button: UpgradeButton = _buttons[option_count-1]
	_buttons.remove_at(option_count-1)
	_button.queue_free()
	
func _redraw_buttons():
	var center: Vector2 = get_viewport_rect().size/2.0
	for ii in range(option_count):
		var _button: UpgradeButton = _buttons[ii]
		var _offset: float = BUTTON_SPACING * (ii - (option_count - 1)/2.)
		
		#_button.text = _upgrades[ii].description
		
		_button.global_position = center - _button.size/2.0 + Vector2(_offset,0)
		#_button.global_position = center - _button.size/2.0 + Vector2(0,_offset)
		
		
	
	
func _on_upgrade_option_count_changed(property: String, new_count):
	if property != "upgrade_option_count": return
	
	var _diff = new_count - option_count
	if _diff == 0: return
	
	if new_count < 1: 
		print("Tried to remove last button")
		return
		
	while _diff != 0:
		if _diff > 0: 
			_create_button()
		else:
			_remove_button()
		_diff = new_count - option_count	
	
	_roll_new_upgrades()
	

func _roll_new_upgrades():
	_upgrades.clear()
	_upgrades.resize(option_count)
	
	for ii in range(option_count):
		var _option: Upgrade
		var _is_okay: bool = false
		var _iters: int = 0
		while not _is_okay:
			_option = possible_upgrades.pick_random()
			
			_is_okay = true
			if not _option.check_possible(gameProperties): _is_okay = false
			for jj in range(ii): if _upgrades[jj] == _option: _is_okay = false
			
			_iters = _iters + 1
			assert(_iters < 999, "Could not find a suitable upgrade.")
			
		_upgrades[ii] = _option
		
	_redraw_buttons()
	

	

	
	
func _present_upgrade_choice():
	if _is_choosing: return
	
	_previous_choice_bounce_count = ballManager.bat_bounce_count
	_is_choosing = true
	get_tree().paused = true
	
	for _button: UpgradeButton in _buttons:
		_button.show()

func _apply_upgrade(index: int):
	if not _is_choosing: return
	_upgrades[index].apply(gameProperties)
	_roll_new_upgrades()
	_close_upgrade_choice()
	upgrade_applied.emit()

func _close_upgrade_choice():
	for _button: Button in _buttons:
		_button.hide()
		
	_is_choosing = false
	get_tree().paused = false


func _on_upgrade_button_pressed(index: int):
	_apply_upgrade(index)
	
func _on_upgrade_button_mouse_entered(index: int):
	_set_selected_button(index)
	
func _on_upgrade_button_mouse_exited(index: int):
	_set_selected_button(-1)
	

func _set_selected_button(index: int):
	if _button_selected == index: return
	_button_selected = index
	description_changed.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _next_count: int = _previous_choice_bounce_count + gameProperties.bounces_between_choices
	if ballManager.bat_bounce_count >= _next_count:
		_present_upgrade_choice()
		
	if Input.is_action_just_pressed("reroll"):
		_roll_new_upgrades()
	
func _input(event):
	if not event is InputEventKey: return
	if not event.pressed: return
	if not _is_choosing: return
	if not event.keycode in KEY_TO_INDEX.keys(): return
	
	var _index = KEY_TO_INDEX[event.keycode] - 1
	if _index >= gameProperties.upgrade_option_count: return
	
	_apply_upgrade(_index)
