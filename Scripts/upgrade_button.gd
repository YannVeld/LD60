class_name UpgradeButton extends Button

@export var index: int = 0
@export var click_sound: AudioStream
@export var hover_sound: AudioStream

@export var next_button: Button
@export var previous_button: Button

@onready var _icon_sprite: Sprite2D = $"./Sprite2D"
@onready var _sound_manager: SoundManager = $"/root/Node2D/SoundManager"

signal pressed_upgrade(index: int)
signal mouse_entered_upgrade(index: int)
signal mouse_exited_upgrade(index: int)

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


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
