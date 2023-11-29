extends CharacterBody3D


const acceleration = 2
const jump_velocity = 4.5
var rot_x = 0
var rot_y = 0
@export var sens = 0.005
@onready var camera = $camera_comp
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction: #null check?
		velocity.x += direction.x * acceleration * delta
		velocity.z += direction.z * acceleration * delta
	#else: #izgleda kao da ovo gasi kretanje kad prestanes da drzis movement
	#	velocity.x = move_toward(velocity.x, 0, acceleration)
	#	velocity.z = move_toward(velocity.z, 0, acceleration)

	move_and_slide() #send movement to charcterbody class ?
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rot_x = -event.relative.x * sens
		rot_y = -event.relative.y * sens
		rot_y = clampf(rot_y, -1.5, 1.5)
		camera.rotate_x(rot_y)
		camera.rotate_y(rot_x)
	
