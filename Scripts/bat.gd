class_name Bat extends StaticBody2D

@export var gameProperties: GameProperties

var _input_dir: float = 0.0

@onready var _bat_shape: CollisionShape2D = $"./CollisionShape2D"
@onready var _bat_sprite: Sprite2D = $"./Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameProperties.property_changed.connect(_on_bat_width_changed)
	_set_bat_width()
	
	pass # Replace with function body.

func _on_bat_width_changed(property: String, new_value=0):
	if property != "bat_width": return
	_set_bat_width()
	
func _set_bat_width():
	var _sprite_width = _bat_sprite.texture.get_width()
	_bat_sprite.scale.x = gameProperties.bat_width / _sprite_width
	_bat_shape.scale.y = gameProperties.bat_width / (4*_sprite_width)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_input_dir = Input.get_axis("move_left", "move_right")


func _physics_process(delta: float) -> void:
	position.x += _input_dir * gameProperties.bat_speed * delta
	
	var _screen_center: Vector2 = get_viewport_rect().size/2.0
	var _bat_width: float = _bat_shape.shape.get_rect().size.y
	
	var _max_x: float = _screen_center.x + gameProperties.wall_distance/2.0 - _bat_width/2.0
	var _min_x: float = _screen_center.x - gameProperties.wall_distance/2.0 + _bat_width/2.0
	
	if position.x  > _max_x: position.x = _max_x
	if position.x  < _min_x: position.x = _min_x
		
