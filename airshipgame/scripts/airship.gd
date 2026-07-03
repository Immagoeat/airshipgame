extends Node3D

@onready var istouching: Area3D = $Istouchingground
@onready var onship: Area3D = $onship

var player
var attached_player: CharacterBody3D = null

var isonground := false
var isdownlocked := false

var upwardspeed = 1
var downwardspeed = -2
var movementspeed = 1
var engine = 2
var isonship = false
var total_movement = 0


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
			if not isdownlocked:
				velocity.y = downwardspeed
				global_position.y += velocity.y * delta
			else:
				pass
			
		if Input.is_action_pressed("up"):
			velocity.x = movementspeed
			total_movement = velocity.x * engine * delta
			global_position.x += total_movement
			if isonship:
				player.global_position.x += total_movement

func lockdownwards():
	isdownlocked = true
	
func unlockdownwards():
	isdownlocked = false

func _on_onship_body_entered(body):
	if body.is_in_group("player"):
		isonship = true
		attached_player = body
		var original_transform = attached_player.global_transform
		
		attached_player.get_parent().remove_child(attached_player)
		add_child(attached_player)
		
		attached_player.global_transform = original_transform

func _on_onship_body_exited(body):
	if body.is_in_group("player"):
		isonship = false

var max_speed: float = 10.0
var acceleration: float = 1.0

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		if player.is_locked:
			current_speed += acceleration * delta
			current_speed = minf(current_speed, max_speed)
			rotate_y(current_speed * delta)
