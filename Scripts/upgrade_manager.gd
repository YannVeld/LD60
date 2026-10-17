class_name UpgradeManager extends Node2D

@export var gameProperties: GameProperties

@onready var ballManager: BallManager = $"../BallManager"

var font: Font = preload("res://Fonts/m6x11.ttf")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ballManager.out_of_bounds.connect(_on_out_of_bounds)
	ballManager.bat_bounce.connect(_on_bat_bounce)


func _on_out_of_bounds(out_of_bounds_count: int):
	queue_redraw()
	
func _on_bat_bounce(bat_bounce_count: int):
	queue_redraw()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	draw_string(font, Vector2(16,16), "Bounces: " + str(ballManager.bat_bounce_count))
	draw_string(font, Vector2(16,32), "Fails: " + str(ballManager.out_of_bounds_count))
