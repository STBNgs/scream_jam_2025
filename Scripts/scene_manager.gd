extends Node

var current_scene: Node = null

func _ready():
	change_scene("res://scenes/MainMenu.tscn")

func change_scene(path: String) -> void:
	# Si hay escena cargada, la borramos
	if current_scene:
		current_scene.queue_free()
	# Instanciamos la nueva
	var inst = load(path).instantiate()
	  # Agregamos la nueva escena de forma segura
	get_tree().root.call_deferred("add_child", inst) # 👈 solución
	# Guardamos referencia
	current_scene = inst
