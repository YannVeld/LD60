class_name BallManager extends Node2D

@export var gameProperties: GameProperties

var ball := preload("res://Scenes/ball.tscn")
var _ball_list: Array[Ball] = []

var ball_count: int:
	get: return _ball_list.size()

signal bat_bounce(bounce_count: int)
var _bat_bounce_count: int = 0
var bat_bounce_count: int:
	get: return _bat_bounce_count
	
signal out_of_bounds(out_of_bounds_count: int)
var _out_of_bounds_count: int = 0
var out_of_bounds_count: int:
	get: return _out_of_bounds_count

func reset():
	_bat_bounce_count = 0
	_out_of_bounds_count = 0

func _ready() -> void:
	gameProperties.property_changed.connect(_on_ball_count_changed)
	
	for ii in range(gameProperties.ball_count):
		var _pos = Vector2.ZERO
		_pos.x = randf_range(-gameProperties.wall_distance/2+16, gameProperties.wall_distance/2-16)
		_spawn_ball(_pos)

func _on_ball_count_changed(property: String, new_value):
	if property != "ball_count": return
	
	var _diff = gameProperties.ball_count - ball_count
	if _diff == 0: return
		
	while _diff != 0:
		if _diff > 0: 
			var _pos = Vector2.ZERO
			_pos.x = randf_range(-gameProperties.wall_distance/2+16, gameProperties.wall_distance/2-16)
			_spawn_ball(_pos)
		else:
			_remove_ball()
		_diff = gameProperties.ball_count - ball_count
		

func _spawn_ball(pos_from_center: Vector2):
	var _inst: Ball = ball.instantiate()
	var center: Vector2 = get_viewport_rect().size/2.0
	_inst.global_position = center + pos_from_center
	add_child(_inst)

	_inst.bat_bounce.connect(_on_bat_bounce)
	_inst.out_of_bounds.connect(_on_ball_out_of_bounds)
	
	_ball_list.append(_inst)

func _remove_ball():
	var _ball: Ball = _ball_list[ball_count-1]
	_ball_list.remove_at(ball_count-1)
	_ball.queue_free()

func _on_bat_bounce():
	_bat_bounce_count += 1
	bat_bounce.emit(_bat_bounce_count)
	
func _on_ball_out_of_bounds():
	_out_of_bounds_count += 1
	out_of_bounds.emit(_out_of_bounds_count)
