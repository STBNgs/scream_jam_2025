extends Area3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _on_body_entered(body: Node3D) -> void:
	audio_stream_player_3d.play()
