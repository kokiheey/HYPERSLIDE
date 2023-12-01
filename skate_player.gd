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
	var direction = (camera.transform.basis.z * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction: #null check?
		velocity.x += direction.x * acceleration * delta
		velocity.z += direction.z * acceleration * delta
	move_and_slide() #send movement to charcterbody class ?
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rot_x += -event.relative.x * sens
		rot_y += -event.relative.y * sens
		rot_y = clampf(rot_y, -1.5, 1.5)
		camera.transform.basis = Basis()
		camera.rotate_object_local(Vector3(0, 1, 0), rot_x)
		camera.rotate_object_local(Vector3(1, 0, 0), rot_y)
