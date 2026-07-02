extends Node3D

var player

var upwardspeed = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_locked:
		if Input.is_action_pressed("space"):
			velocity.y = upwardspeed * delta
