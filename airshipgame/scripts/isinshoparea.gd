extends Area3D

var player
var player_in_range := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_pressed("e"):
		get_tree().change_scene_to_file("res://scenes/shopui.tscn")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
