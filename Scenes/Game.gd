extends Node3D

func _ready():
	load_room("res://scenes/Room1.tscn")

func load_room(path: String):
	for c in $LevelRoot.get_children():
		c.queue_free()
	var room = load(path).instantiate()
	$LevelRoot.add_child(room)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var paused := get_tree().paused
		get_tree().paused = not paused
		$PauseMenu.visible = not paused
