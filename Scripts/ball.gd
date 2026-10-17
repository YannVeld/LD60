class_name Ball extends RigidBody2D 

@export var gameProperties: GameProperties

const MAXSPEED: float = 2000.0

var initial_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = global_position
	
	body_entered.connect(_on_body_entered)
	
	var _outArea: Area2D = $"../OutArea"
	_outArea.body_entered.connect(_on_out_area_entered)
	
	_respawn(0.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if linear_velocity.length() > MAXSPEED:
		linear_velocity = linear_velocity.normalized() * MAXSPEED
		
	

func _respawn(respawn_time: float):
	set_deferred("freeze", true)
	
	global_position = initial_pos
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(respawn_time).timeout
	var vel: Vector2 = Vector2.LEFT.rotated(PI*randf())
	linear_velocity = vel * gameProperties.ball_speed
	
	set_deferred("freeze", false)
	
	
func _on_body_entered(body: Node):
	if body is Bat:
		set_axis_velocity(linear_velocity + Vector2.UP * gameProperties.bat_boost)
	
func _on_out_area_entered(body: Node2D):
	if not body == self: return
	_respawn(gameProperties.ball_respawn_time)
