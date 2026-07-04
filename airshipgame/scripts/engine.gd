extends Node3D

@onready var isinarea: Area3D = $Area3D

var player_in_range := false
var engineon = false
@onready var airship = get_parent()
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if player_in_range:
		if Input.is_action_pressed("e"):
			engineon = not engineon
			airship.engine = 4 if engineon else 1

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
