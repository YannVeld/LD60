class_name Ball extends RigidBody2D 

@export var gameProperties: GameProperties

var initial_pos: Vector2

signal bat_bounce
signal out_of_bounds

@onready var _col_shape: CollisionShape2D = $"./CollisionShape2D"
@onready var _sprite: Sprite2D = $"./Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = global_position
	gameProperties.property_changed.connect(_on_property_changed)
	
	body_entered.connect(_on_body_entered)
	
	var _outArea: Area2D = $"/root/Node2D/OutArea"
	_outArea.body_entered.connect(_on_out_area_entered)
	
	_reset_size()
	_respawn(0.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if linear_velocity.length() > gameProperties.ball_max_speed:
		linear_velocity = linear_velocity.normalized() * gameProperties.ball_max_speed

func _respawn(respawn_time: float):
	set_deferred("freeze", true)
	
	global_position = initial_pos
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(respawn_time).timeout
	var vel: Vector2 = Vector2.LEFT.rotated(PI*randf())
	linear_velocity = vel * gameProperties.ball_initial_speed
	
	set_deferred("freeze", false)
	
	
func _on_body_entered(body: Node):
	if body is Bat:
		set_axis_velocity(linear_velocity + Vector2.UP * gameProperties.bat_boost)
		bat_bounce.emit()
	
func _on_out_area_entered(body: Node2D):
	if not body == self: return
	out_of_bounds.emit()
	_respawn(gameProperties.ball_respawn_time)
	
func _on_property_changed(property: String, new_value):
	if property != "ball_size": return
	_reset_size()
	
func _reset_size():
	var _radius: float = 8
	match gameProperties.ball_size:
		1: _radius = 2 
		2: _radius = 4
		3: _radius = 8
		4: _radius = 12
		5: _radius = 16
		
	_col_shape.shape.radius = _radius
	_sprite.global_scale = Vector2.ONE * 2 * _radius / _sprite.texture.get_size().x
