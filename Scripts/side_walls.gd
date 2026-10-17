extends StaticBody2D

@export var gameProperties: GameProperties

@onready var _left_wall: CollisionShape2D = $"./left"
@onready var _right_wall: CollisionShape2D = $"./right"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameProperties.property_changed.connect(_on_wall_distance_changed)
	_update_wall_distance()
	

func _on_wall_distance_changed(property: String, new_value):
	if property != "wall_distance": return
	_update_wall_distance()
	
func _update_wall_distance():
	var center: Vector2 = get_viewport_rect().size/2.0
	_left_wall.global_position.x = center.x - gameProperties.wall_distance / 2.0
	_right_wall.global_position.x = center.x + gameProperties.wall_distance / 2.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
