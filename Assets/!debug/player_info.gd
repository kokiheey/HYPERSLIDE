extends CanvasLayer
@onready var velocity_label = $velocity_text
var velocity:
	set(value):
		velocity = value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if velocity is Vector3:
		velocity_label.text = "(" +  str(velocity.x) + ", " + str(velocity.y) + ", " + str(velocity.z) + ")"
	else:
		velocity_label.text = "no speed"
