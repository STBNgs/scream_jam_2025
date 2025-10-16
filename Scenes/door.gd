extends Area3D

@export var next_room_path: String = "res://scenes/room2.tscn"
var player_in_area := false

func _on_body_entered(body):
	print("Player insie")
	if body.name == "Player":
		print("Player insie")
		player_in_area = true

func _ready():
	set_process_unhandled_input(true)
func _on_body_exited(body):
	print("Player insie")
	if body.name == "Player":
		print("Player insie")
		player_in_area = false

func _unhandled_input(event):
	if player_in_area and event.is_action_pressed("interact"):

		var game = get_parent().get_parent().get_parent()
		print("deberia cargar")
		print(game.name)
		if game and game.has_method("load_room"):
			print("deberia cargar")
			game.load_room(next_room_path)
