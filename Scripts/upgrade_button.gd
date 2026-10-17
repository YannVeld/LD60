class_name UpgradeButton extends Button

@export var index: int = 0

signal pressed_upgrade(index: int)

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed():
	pressed_upgrade.emit(index)
	
