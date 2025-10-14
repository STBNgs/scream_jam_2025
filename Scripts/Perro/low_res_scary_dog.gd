extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area: Area3D = $Area3D

var velocidad: float = 3.0
var objetivo: Node3D = null
var patrulla: Array = [Vector3(0,0,0), Vector3(10,0,0), Vector3(10,0,10), Vector3(0,0,10)]
var indice_patrulla: int = 0
var persiguiendo: bool = false

func _ready():
	vision_area.body_entered.connect(_on_vision_enter)
	vision_area.body_exited.connect(_on_vision_exit)
	nav_agent.target_position = patrulla[indice_patrulla]

func _physics_process(delta: float):
	if persiguiendo and objetivo:
		nav_agent.target_position = objetivo.global_position
	elif not persiguiendo and nav_agent.is_navigation_finished():
		indice_patrulla = (indice_patrulla + 1) % patrulla.size()
		nav_agent.target_position = patrulla[indice_patrulla]

	if nav_agent.is_target_reachable():
		var dir = (nav_agent.get_next_path_position() - global_position).normalized()
		velocity = dir * velocidad
		move_and_slide()

func _on_vision_enter(body: Node):
	if body.name == "Player": # cambia por el nombre real del nodo jugador
		objetivo = body
		persiguiendo = true

func _on_vision_exit(body: Node):
	if body == objetivo:
		objetivo = null
		persiguiendo = false
