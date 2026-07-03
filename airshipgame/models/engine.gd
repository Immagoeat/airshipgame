extends Node3D

@onready var isinarea: Area3D = $Area3D

var player_in_range: bool = false
var engineon = false
var airship
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	airship = get_tree().get_first_node_in_group("airship")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_pressed("e") and not engineon:
			engineon = true
			airship.engine = 4
		elif Input.is_action_pressed("e") and engineon:
			engineon = false
			airship.engine = 1
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
