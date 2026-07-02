extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const RUN_SPEED = 7.5

var mousemode: bool = true
var esc_cooldown: bool = false
var is_locked: bool = false

@onready var camera: Camera3D = $Camera3D
@onready var anim: AnimationPlayer = $bob

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mousemode:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_action_pressed("esc"):
		if mousemode:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mousemode = false
			get_tree().change_scene_to_file("res://scenes/pausemenu.tscn")

func _physics_process(delta: float) -> void:
	if is_locked:
		if Input.is_action_pressed("shift"):
			unlock()
		velocity.x = 0
		velocity.z = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var speed = RUN_SPEED if Input.is_action_pressed("shift") else SPEED
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
			
	var is_moving = Vector2(velocity.x, velocity.z).length() > 0.1
	if is_moving and is_on_floor():
		anim.play("bobbing")
		# Speed up the animation when running
		anim.speed_scale = 1.6 if Input.is_action_pressed("shift") else 1.0
	else:
		# Smoothly stop bobbing and reset camera position
		anim.speed_scale = 1.0
		anim.stop()

	move_and_slide()
	
func lock():
	is_locked = true

func unlock():
	is_locked = false
