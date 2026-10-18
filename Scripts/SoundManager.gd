class_name SoundManager extends Node2D

@export var _player_count: int = 5

var _players: Array[AudioStreamPlayer2D] = []
var _index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_players.clear()
	_players.resize(_player_count)
	for ii in range(_player_count):
		var _player := AudioStreamPlayer2D.new()
		_player.set_bus("Sounds")
		_players[ii] = _player
		add_child(_player)

func play_sound(sound: AudioStream, pitch_randomizer: float = 0.0):
	var _player := _players[_index]
	
	_player.stop()
	_player.stream = sound
	_player.pitch_scale = 1.0 + randf_range(-pitch_randomizer, pitch_randomizer)
	_player.play()

	_index += 1
	if _index >= _player_count:
		_index = 0
