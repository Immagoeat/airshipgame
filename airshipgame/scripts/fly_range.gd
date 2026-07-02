extends Area3D

@onready var bob = $"Teleport point".global_position

var player_in_range := false
var player

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_pressed("e"):
			player.lock()
			player.position = bob

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
