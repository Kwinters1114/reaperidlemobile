extends Node

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var volume = 0
var pitch = 1
var stream

func _ready() -> void:
	audio.volume_db = volume
	audio.pitch_scale = pitch
	audio.stream = stream
	audio.play()


func _on_audio_stream_player_finished() -> void:
	queue_free()
