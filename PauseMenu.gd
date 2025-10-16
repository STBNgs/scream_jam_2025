extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


func _on_resume_pressed():
	get_tree().paused = false
	hide()

func _on_exit_pressed():
	get_tree().paused = false
	SceneManager.change_scene("res://scenes/MainMenu.tscn")
