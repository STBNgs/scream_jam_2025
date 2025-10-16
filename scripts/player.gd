extends CharacterBody3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Pivot/Camera3D/AudioStreamPlayer3D
@onready var landing: AudioStreamPlayer3D = $Pivot/Camera3D/landing

@onready var pivot: Node3D = $Pivot
@export var mouse_sensitivity := 0.2

const CLIMB_SPEED = 2.5

# for landing sound
var is_on_ground = false
var was_falling = false


const WALK_SPEED = 2.0
const RUN_SPEED = 7.0
const ON_WALL_SPEED = 0.1
const JUMP_VELOCITY = 5.0
var speed = WALK_SPEED


func _ready():
	landing.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, -80, 80)

func _physics_process(delta: float) -> void:
	is_on_ground = is_on_floor()
	if is_on_ground and was_falling:
		landing.play()
		was_falling = false
		
	if !is_on_ground and velocity.y < 0:
		was_falling = true


	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		audio_stream_player_3d.play()
	if Input.is_action_pressed("shift"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if is_on_wall():
		speed = 0.1
		if Input.is_action_pressed("up"):
			velocity.y = CLIMB_SPEED
	else:
		speed = WALK_SPEED

	move_and_slide()
