extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var speed: float = 3.0

func _ready():
	# punto fijo al que queremos que camine (ajusta coordenadas a tu mapa)
	nav.target_position = Vector3(10, 0, 10)

func _physics_process(delta: float):
	if nav.is_target_reachable():
		var next_pos := nav.get_next_path_position()
		var dir := (next_pos - global_position).normalized()
		dir.y = 0.0 # no subir/bajar
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
