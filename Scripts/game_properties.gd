class_name GameProperties extends Resource



@export var ball_speed: float = 500.0

@export var bat_boost: float = 100.0
@export var bat_speed: float = 500.0

signal bat_width_changed
@export var bat_width: float = 64.0:
	set(value): 
		if value <= 1.0: value = 1.0
		bat_width = value
		bat_width_changed.emit()

@export var ball_respawn_time: float = 2.0


signal wall_distance_changed
@export var wall_distance: float = 180:
	set(value): 
		if value <= 1.0: value = 1.0
		wall_distance = value
		wall_distance_changed.emit()
