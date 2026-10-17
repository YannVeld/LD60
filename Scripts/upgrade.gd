class_name Upgrade extends Resource

@export var property_name: String = "ball_max_speed"

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
	var _new_value = _get_new_value(gameProperties)
	if not check_possible(gameProperties, _new_value):
		print("Upgrade not valid!")
		return

	gameProperties.set(property_name, _new_value)


func check_possible(gameProperties: GameProperties, value) -> bool:
	if not gameProperties.has_method("check_"+property_name):
		return true
	return gameProperties.call("check_"+property_name, value)
