extends Node3D

@onready var istouching: Area3D = $Istouchingground
@onready var onship: Area3D = $onship

var player
var isonship := false
var isdownlocked := false

var upwardspeed = 1
var downwardspeed = -2
var movementspeed = 0.1
var engine = 1

var max_speed: float = 1
var acceleration: float = 0.2
var current_speed: float = 0.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if not player.is_locked:
		current_speed = 0.0
		return


	var old_transform: Transform3D = global_transform


	if Input.is_action_pressed("space"):
		global_position.y += upwardspeed * delta

	if Input.is_action_pressed("ctrl") and not isdownlocked:
		global_position.y += downwardspeed * delta


	var forward: Vector3 = global_transform.basis.x 

	if Input.is_action_pressed("up"):
		global_position += forward * movementspeed * engine * delta

	if Input.is_action_pressed("down"):
		global_position -= forward * movementspeed * engine * delta

	var turning_right := Input.is_action_pressed("right")
	var turning_left := Input.is_action_pressed("left")

	if turning_right or turning_left:
		current_speed = minf(current_speed + acceleration * delta, max_speed)
		if turning_right:
			rotate_y(-current_speed * delta)
		if turning_left:
			rotate_y(current_speed * delta)
	else:
		current_speed = 0.0

	if isonship and player:
		var delta_transform: Transform3D = global_transform * old_transform.affine_inverse()
		player.global_transform = delta_transform * player.global_transform


func lockdownwards() -> void:
	isdownlocked = true


func unlockdownwards() -> void:
	isdownlocked = false


func _on_onship_body_entered(body) -> void:
	if body.is_in_group("player"):
		isonship = true


func _on_onship_body_exited(body) -> void:
	if body.is_in_group("player"):
		isonship = false
