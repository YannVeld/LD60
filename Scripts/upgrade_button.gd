class_name UpgradeButton extends Button

@export var index: int = 0
@export var click_sound: AudioStream
@export var hover_sound: AudioStream

@export var next_button: Button
@export var previous_button: Button

@onready var _icon_sprite: Sprite2D = $"./Sprite2D"
@onready var _sound_manager: SoundManager = $"/root/Node2D/SoundManager"

@export var _button_normal_sprite: Texture2D = preload("res://Sprites/UpgradeButton.png")
@export var _button_selected_sprite: Texture2D = preload("res://Sprites/UpgradeButton_selected.png")

signal pressed_upgrade(index: int)
signal mouse_entered_upgrade(index: int)
signal mouse_exited_upgrade(index: int)

var _selected: bool = false

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	var _style: StyleBoxTexture = get_theme_stylebox("normal")
	var _new_style = StyleBoxTexture.new()
	_new_style.copy_from_resource(_style)
	
	add_theme_stylebox_override("normal", _new_style)
	add_theme_stylebox_override("pressed", _new_style)
	add_theme_stylebox_override("hover", _new_style)
	add_theme_stylebox_override("disabled", _new_style)
	add_theme_stylebox_override("focus", _new_style)


func _on_pressed():
	pressed_upgrade.emit(index)
	_sound_manager.play_sound(click_sound)
	
func _on_mouse_entered():
	mouse_entered_upgrade.emit(index)
	_sound_manager.play_sound(hover_sound)
	
func _on_mouse_exited():
	mouse_exited_upgrade.emit(index)

func set_icon(texture: Texture2D):
	_icon_sprite.texture = texture

func set_button_highlight(selected: bool):
	var _style: StyleBoxTexture = get_theme_stylebox("normal")
	if selected:
		_style.texture = _button_selected_sprite
	else:
		_style.texture = _button_normal_sprite

func on_select_index(selected_index: int):
	if selected_index == index:
		_selected = true
	else:
		_selected = false
	set_button_highlight(_selected)
