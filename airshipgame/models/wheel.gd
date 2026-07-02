extends CSGMesh3D

@onready var flyrange: CollisionShape3D = $"Fly range/CollisionShape3D"

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right") and player.is_locked:
		turn_wheel_right()
	if Input.is_action_just_pressed("left") and player.is_locked:
		turn_wheel_left()

func turn_wheel_right():
	var tween = create_tween()
	# Interpolates the property to 90 degrees over 1.5 seconds smoothly
	tween.tween_property(self, "rotation_degrees:x", 360.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func turn_wheel_left():
	var tween = create_tween()
	# Interpolates the property to 90 degrees over 1.5 seconds smoothly
	tween.tween_property(self, "rotation_degrees:x", -360.0, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
