extends StaticBody2D

@export var gameProperties: GameProperties

@onready var _left_wall: CollisionShape2D = $"./left"
@onready var _right_wall: CollisionShape2D = $"./right"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameProperties.property_changed.connect(_on_property_changed)
	_update_wall_distance()
	_set_wall_colors()
	_update_wall_angle()
	

func _on_property_changed(property: String, new_value):
	if property == "wall_distance":
		_update_wall_distance()
	
	if property == "wall_angle":
		_update_wall_angle()
	
func _update_wall_distance():
	var center: Vector2 = get_viewport_rect().size/2.0
	_left_wall.global_position.x = center.x - gameProperties.wall_distance / 2.0
	_right_wall.global_position.x = center.x + gameProperties.wall_distance / 2.0

func _update_wall_angle():
	_left_wall.rotation_degrees = 270 + gameProperties.wall_angle
	_right_wall.rotation_degrees = 90 - gameProperties.wall_angle

func _set_wall_colors():
	var _rect_left: ColorRect = $"./left/ColorRect"
	_rect_left.color = gameProperties.raw_color_palette.get_colors()[1]
	var _rect_right: ColorRect = $"./right/ColorRect"
	_rect_right.color = gameProperties.raw_color_palette.get_colors()[1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
