class_name GameProperties extends Resource



@export var ball_speed: float = 500.0
@export var bat_boost: float = 100.0

@export var ball_respawn_time: float = 2.0


signal wall_distance_changed
@export var wall_distance: float = 180:
	set(value): 
		wall_distance = value
		wall_distance_changed.emit()
