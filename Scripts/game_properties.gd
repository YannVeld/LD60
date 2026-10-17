class_name GameProperties extends Resource

signal property_changed(property: String, new_value)


var _initial_copy: GameProperties
func initialize():
	_initial_copy = duplicate(true)

func reset():
	assert(_initial_copy != null, "Resource was not initialized before reset")
	for _prop in get_property_list():
		if not (_prop["usage"] & PROPERTY_USAGE_STORAGE): continue
		var _name: String = _prop["name"]
		set(_name, _initial_copy.get(_name))


@export_group("Ball")
@export var ball_initial_speed: float = 500.0:
	set(value):
		if ball_initial_speed == value: return
		ball_initial_speed = value
		property_changed.emit("ball_initial_speed", value)

@export var ball_max_speed: float = 500.0:
	set(value):
		if ball_max_speed == value: return
		if not check_ball_max_speed(value): return
		ball_max_speed = value
		property_changed.emit("ball_max_speed", value)
func check_ball_max_speed(value: int) -> bool:
	if value <= 2000: return false
	return true

@export var ball_respawn_time: float = 1.0:
	set(value):
		if ball_respawn_time == value: return
		ball_respawn_time = value
		property_changed.emit("ball_respawn_time", value)

@export var ball_count: int = 1:
	set(value):
		if not check_ball_count(value): return
		if ball_count == value: return
		ball_count = value
		property_changed.emit("ball_count", value)
func check_ball_count(value: int) -> bool:
	if value <= 0: return false
	return true
	
@export var ball_size: int = 5:
	set(value):
		if not check_ball_size(value): return
		if ball_size == value: return
		ball_size = value
		property_changed.emit("ball_size", value)
func check_ball_size(value: int) -> bool:
	if value <= 0: return false
	if value > 5: return false
	return true




@export_group("Bat")
@export var bat_boost: float = 100.0:
	set(value):
		if bat_boost == value: return
		bat_boost = value
		property_changed.emit("bat_boost", value)

@export var bat_speed: float = 500.0:
	set(value):
		if bat_speed == value: return
		bat_speed = value
		property_changed.emit("bat_speed", value)

@export var bat_width: float = 64.0:
	set(value):
		if not check_bat_width(value): return
		if bat_width == value: return
		bat_width = value
		property_changed.emit("bat_width", value)
func check_bat_width(value: float) -> bool:
	if value <= 1.0: return false
	return true






@export_group("Game Area")

@export var wall_distance: float = 180:
	set(value):
		if not check_wall_distance(value): return
		if wall_distance == value: return
		wall_distance = value
		property_changed.emit("wall_distance", value)
func check_wall_distance(value: float) -> bool:
	if value <= 1.0: return false
	if value > 640.0: return false
	return true





@export_group("Gameplay")

@export var bounces_between_choices: int = 5:
	set(value):
		if bounces_between_choices == value: return
		bounces_between_choices = value
		property_changed.emit("bounces_between_choices", value)

@export var upgrade_option_count: int = 3:
	set(value):
		if not check_upgrade_option_count(value): return
		if upgrade_option_count == value: return
		upgrade_option_count = value
		property_changed.emit("upgrade_option_count", value)
func check_upgrade_option_count(value: int) -> bool:
	if value <= 0: return false
	return true
	
@export var max_lives: int = 5:
	set(value):
		if max_lives == value: return
		max_lives = value
		property_changed.emit("max_lives", value)
func check_max_lives(value: int) -> bool:
	if value <= 0: return false
	return true
	
	
@export var bounce_count_for_life_gain: int = 3:
	set(value):
		if bounce_count_for_life_gain == value: return
		bounce_count_for_life_gain = value
		property_changed.emit("bounce_count_for_life_gain", value)
