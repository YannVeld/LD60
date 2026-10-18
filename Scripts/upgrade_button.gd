class_name UpgradeButton extends Button

@export var index: int = 0

signal pressed_upgrade(index: int)
signal mouse_entered_upgrade(index: int)
signal mouse_exited_upgrade(index: int)

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed():
	pressed_upgrade.emit(index)
	
func _on_mouse_entered():
	mouse_entered_upgrade.emit(index)
	
func _on_mouse_exited():
	mouse_exited_upgrade.emit(index)
