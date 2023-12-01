extends CharacterBody3D

const acceleration = 2
const jump_velocity = 4.5
var rot_x = 0
var rot_y = 0
var forward:
	get:
		return -camera.transform.z
@export var sens = 0.001:
	set(new_value):
		sens = new_value
@onready var camera = $camera_comp
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
