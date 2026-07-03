extends CSGMesh3D

@onready var flyrange: CollisionShape3D = $"Fly range/CollisionShape3D"

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("right") and player.is_locked:
		turn_wheel_right()
	elif Input.is_action_pressed("left") and player.is_locked:
		turn_wheel_left()
	else:
		center_wheel()

func turn_wheel_right():
	var tween = create_tween()
	# Interpolates the property to 90 degrees over 1.5 seconds smoothly
	tween.tween_property(self, "rotation_degrees:x", 360.0, 3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func turn_wheel_left():
	var tween = create_tween()
	# Interpolates the property to 90 degrees over 1.5 seconds smoothly
	tween.tween_property(self, "rotation_degrees:x", -360.0, 3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func center_wheel():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:x", 0, 3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
