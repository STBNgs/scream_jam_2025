extends Area3D

@export var next_room_path: String = "res://scenes/exterior_1.tscn"
var player_in_area := false

func _on_body_entered(body):
	print("palyer room2")
	if body.name == "Player":
		print("palyer room2")
		player_in_area = true

func _on_body_exited(body):
	print("palyer ex room2")
	if body.name == "Player":
		print("palyer ex room2")
		player_in_area = false

func _unhandled_input(event):
	if player_in_area and event.is_action_pressed("interact"):
		print("palyer unhan room2")
		var game = get_parent().get_parent().get_parent()
		if game and game.has_method("load_room"):
			game.load_room(next_room_path)
