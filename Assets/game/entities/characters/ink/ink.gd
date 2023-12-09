extends CharacterBody3D

#region test
const acceleration = 5
const move_speed = 20
const jump_velocity = 7
const brake_strength = 1
const drag = 3
#endregion

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

	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("mouse_right") and is_on_floor():
		velocity.lerp(Vector3(0, 0, 0), velocity.length_squared())
	
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (camera.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		velocity += direction * acceleration * delta
		velocity.x = lerp(velocity.x, (velocity.x if input_dir.x != 0 and input_dir else 0.0), \
		brake_strength * delta)
		velocity.z = lerp(velocity.z, (velocity.z if input_dir.y != 0 and input_dir else 0.0), \
		brake_strength * delta)
		velocity.lerp(Vector3(0, velocity.y, 0), clamp(drag * velocity.length_squared(), 0, 100) / 100.0)
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var roty = -event.relative.y * sens
		if camera.rotation.x + roty < PI/2 and camera.rotation.x > -PI/2:
			camera.rotate_x(-event.relative.y * sens)
		rotate_y(-event.relative.x * sens)
