extends Node3D
@onready var player_info = $player_info
@onready var player = $ink
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_info.velocity = player.velocity
