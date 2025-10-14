extends CharacterBody3D

# ===== Movimiento =====
const SPEED = 5.0
const SPRINT_MULTIPLIER = 1.8   # cuánto más rápido corre con shift

# ===== Salto cargado =====
const MIN_JUMP = 2.0
const MAX_JUMP = 4.0
const CHARGE_RATE = 20.0
var charging_jump = false
var jump_power = 0.0

# ===== Cámara =====
const MOUSE_SENSITIVITY = 0.002
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var yaw: float = 0.0   # rotación en Y (izq/der)
var roll: float = 0.0  # rotación en Z (arriba/abajo)

# ===== Escalada =====
const CLIMB_SPEED = 3.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Rotación horizontal → Player en Y
		yaw -= event.relative.x * MOUSE_SENSITIVITY
		rotation.y = yaw

		# Rotación vertical → "Head" en Z
		roll -= event.relative.y * MOUSE_SENSITIVITY
		roll = clamp(roll, deg_to_rad(-80), deg_to_rad(80))
		head.rotation.z = roll

func _physics_process(delta: float) -> void:
	# Gravedad (si no escala)
	if not is_on_floor() and not (is_on_wall() and Input.is_action_pressed("up")):
		velocity += get_gravity() * delta

	# Salto cargado
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			charging_jump = true
			jump_power = clamp(jump_power + CHARGE_RATE * delta, MIN_JUMP, MAX_JUMP)
		elif charging_jump and Input.is_action_just_released("ui_accept"):
			velocity.y = jump_power
			charging_jump = false
			jump_power = 0.0
	else:
		charging_jump = false
		jump_power = 0.0

	# Movimiento WASD con Sprint
	var input_dir := Input.get_vector("down", "up", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var current_speed = SPEED
	if Input.is_action_pressed("sprint"): # acción personalizada en Input Map
		current_speed *= SPRINT_MULTIPLIER

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Escalada
	if is_on_wall() and Input.is_action_pressed("up"):
		velocity.y = CLIMB_SPEED

	move_and_slide()
