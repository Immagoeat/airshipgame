extends Node3D

var player

var upwardspeed = 1
var downwardspeed = -2


var velocity: Vector3 = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_locked:
		if Input.is_action_pressed("space"):
			velocity.y = upwardspeed
			global_position.y += velocity.y * delta
			
		if Input.is_action_pressed("ctrl"):
			velocity.y = downwardspeed
			global_position.y += velocity.y * delta
