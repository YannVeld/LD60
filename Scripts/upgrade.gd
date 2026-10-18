class_name Upgrade extends Resource

@export var property_name: String = "ball_max_speed"
@export var icon: Texture2D = preload("res://Sprites/UpgradeButton/Upgrade_unknown.png")

enum Operation {ADD, MULTIPLY, SET}

@export var operation: Operation = Operation.ADD
@export var value = 1.0

@export_multiline var description: String = ""

func _get_new_value(gameProperties: GameProperties):
	var _current_value = gameProperties.get(property_name)
	
	match operation:
		Operation.ADD: return _current_value+value
		Operation.MULTIPLY: return _current_value*value
		Operation.SET: return value

func apply(gameProperties: GameProperties):
	if not check_possible(gameProperties):
		print("Upgrade not valid!")
		return

	var _new_value = _get_new_value(gameProperties)
	gameProperties.set(property_name, _new_value)


func check_possible(gameProperties: GameProperties) -> bool:
	if not gameProperties.has_method("check_"+property_name):
		return true
		
	var _new_value = _get_new_value(gameProperties)
	return gameProperties.call("check_"+property_name, _new_value)
