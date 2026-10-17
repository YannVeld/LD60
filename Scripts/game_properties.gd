class_name GameProperties extends Resource


@export_group("Ball")
@export var ball_initial_speed: float = 500.0

@export var ball_max_speed: float = 500.0:
	set(value): 
		if not check_ball_max_speed(value): return
		ball_max_speed = value
func check_ball_max_speed(value: int) -> bool:
	if value <= 2000: return false
	return true

@export var ball_respawn_time: float = 1.0

signal ball_count_changed
@export var ball_count: int = 1:
	set(value): 
		if not check_ball_count(value): return
		ball_count = value
		ball_count_changed.emit()
func check_ball_count(value: int) -> bool:
	if value <= 0: return false
	return true


@export_group("Bat")
@export var bat_boost: float = 100.0
@export var bat_speed: float = 500.0

signal bat_width_changed
@export var bat_width: float = 64.0:
	set(value): 
		if not check_bat_width(value): return
		bat_width = value
		bat_width_changed.emit()
func check_bat_width(value: float) -> bool:
	if value <= 1.0: return false
	return true

@export_group("Game Area")

signal wall_distance_changed
@export var wall_distance: float = 180:
	set(value): 
		if not check_wall_distance(value): return
		wall_distance = value
		wall_distance_changed.emit()
func check_wall_distance(value: float) -> bool:
	if value <= 1.0: return false
	return true

@export_group("Gameplay")

@export var bounces_between_choices: int = 5

signal upgrade_option_count_changed(count: int)
@export var upgrade_option_count: int = 3:
	set(value): 
		if not check_upgrade_option_count(value): 
			print("Cannot reduce upgrades further")
			return
		upgrade_option_count = value
		upgrade_option_count_changed.emit(value)
func check_upgrade_option_count(value: int) -> bool:
	if value <= 0: return false
	return true
