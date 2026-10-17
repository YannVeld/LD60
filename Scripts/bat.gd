class_name Bat extends StaticBody2D

const SPEED: float = 500.0

var input_dir: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_dir = Input.get_axis("move_left", "move_right")


func _physics_process(delta: float) -> void:
	position.x += input_dir * SPEED * delta
	
