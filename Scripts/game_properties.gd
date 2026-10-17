class_name GameProperties extends Resource


@export_group("Ball")
@export var ball_speed: float = 500.0
@export var ball_respawn_time: float = 2.0

signal ball_count_changed
@export var ball_count: int = 1:
	set(value): 
		if value <= 0: value = 0
		ball_count = value
		ball_count_changed.emit()

@export_group("Bat")
@export var bat_boost: float = 100.0
@export var bat_speed: float = 500.0

signal bat_width_changed
@export var bat_width: float = 64.0:
	set(value): 
		if value <= 1.0: value = 1.0
		bat_width = value
		bat_width_changed.emit()


@export_group("Game Area")

signal wall_distance_changed
@export var wall_distance: float = 180:
	set(value): 
		if value <= 1.0: value = 1.0
		wall_distance = value
		wall_distance_changed.emit()


@export_group("Gameplay")

@export var bounces_between_choices: int = 5

signal upgrade_option_count_changed(count: int)
@export var upgrade_option_count: int = 3:
	set(value): 
		if value <= 0: 
			print("Cannot reduce upgrades further")
			value = 1
		upgrade_option_count = value
		upgrade_option_count_changed.emit(value)
